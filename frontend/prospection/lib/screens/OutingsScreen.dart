// lib/screens/outings_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isetagcom/utils/themes/app_colors.dart';
import 'package:isetagcom/services/translation_service.dart';
import 'package:provider/provider.dart';
import '../models/source.dart';
import '../models/fiche.dart';
import '../models/localStorage/local_storage.dart';
import '../provider/auth_provider.dart';
import '../services/api_service.dart';
import '../services/loading_service.dart';
import '../utils/idGenerator.dart';
import '../utils/status.dart';

class OutingsScreen extends StatefulWidget {
  const OutingsScreen({super.key});

  @override
  State<OutingsScreen> createState() => _OutingsScreenState();
}

class _OutingsScreenState extends State<OutingsScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _cachedParticipationId;
  Map<String, dynamic>? _currentParticipationData;
  String? _serverError;
  bool _ficheCreated = false;

  final ApiService _apiService = ApiService();
  final LoadingService _loadingService = LoadingService();

  // ✅ Retry configuration
  static const int _maxRetries = 3;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCachedParticipationData();
    _checkParticipationWithRetry();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  // ✅ Load cached participation data from SharedPreferences
  Future<void> _loadCachedParticipationData() async {
    final authProvider = context.read<AuthProvider>();
    _cachedParticipationId = await authProvider.getCachedParticipationId();
    _currentParticipationData = await authProvider.getCachedParticipationData();
    print('📦 Cached Participation ID: $_cachedParticipationId');
  }

  // ✅ Check participation with retry logic
  Future<void> _checkParticipationWithRetry() async {
    setState(() {
      _isLoading = true;
      _serverError = null;
      _retryCount = 0;
      _ficheCreated = false;
    });

    await _attemptCheckParticipation();
  }

  // ✅ Aplatit la réponse serveur
  Map<String, dynamic>? _normalizeParticipationResponse(
      Map<String, dynamic> raw) {
    final sortie = raw['sortie'];
    if (sortie is! Map) return null;

    final sortieMap = Map<String, dynamic>.from(sortie);
    final participationId = raw['idParticipation']?.toString();
    if (participationId == null || participationId.isEmpty) return null;

    return <String, dynamic>{
      ...sortieMap,
      'idParticipation': participationId,
    };
  }

  // ✅ Create source and fiche simply
  Future<void> _createSourceAndFiche(Map<String, dynamic> data) async {
    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;

      if (user == null) {
        print('❌ User not authenticated, cannot create fiche');
        return;
      }

      final participationId = data['idParticipation'];
      final location = data['zone_detail']?['ville'] ?? 'N/A';

      // ✅ Check if fiche already exists for this participation
      final localStorage = LocalStorage.instance;
      await localStorage.init();

      // final existingFiche = await localStorage.getFicheByParticipationId(participationId);
      // if (existingFiche != null) {
      //   print('ℹ️ Fiche already exists for participation $participationId');
      //   _ficheCreated = true;
      //   return;
      // }

      final now = DateTime.now();

      // ✅ 1. Create Source
      final source = Source(
        idSource: 'SRC-843E6B48',
        libelleSource: 'Prospection Terrain',
        createdAt: now,
        syncState: SyncState.synced,
      );

      // 2. Save Source only
      await localStorage.saveSource(source);
      print('Source saved: ${source.idSource}');

      // 3. Create Fiche
      final fiche = Fiche(
        idFiche: Generator.generateShortId('fiche_'),
        idSrc: source.idSource,
        dateCollecte: now,
        commentaire: 'Fiche automatique pour la sortie du ${data['dateSortie'] ?? ''} - $location',
        scoreInteret: 0,
        createdAt: now,
        isCurrent: true,
        syncState: SyncState.pending,
      );

      // ✅ 4. Save Fiche only
      await localStorage.saveFiche(fiche);
      print('✅ Fiche saved: ${fiche.idFiche}');

      _ficheCreated = true;
      print('✅ Fiche created successfully for participation: $participationId');

    } catch (e) {
      print('❌ Error creating fiche: $e');
      _ficheCreated = false;
    }
  }

  Future<void> _attemptCheckParticipation() async {
    _retryCount++;

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;

      if (user == null) {
        setState(() {
          _isLoading = false;
          _serverError = 'user_not_authenticated'.tr;
        });
        return;
      }

      final result = await _apiService.checkParticipation();

      if (result != null) {
        if (result['error'] == true) {
          if (result['isServerError'] == true && _retryCount < _maxRetries) {
            await Future.delayed(const Duration(seconds: 2));
            await _attemptCheckParticipation();
            return;
          }

          if (result['statusCode'] != null &&
              result['statusCode'] >= 400 &&
              result['statusCode'] < 500) {
            setState(() {
              _isLoading = false;
              _serverError = result['message'] ?? 'server_error'.tr;
            });
            return;
          }

          if (_retryCount < _maxRetries) {
            await Future.delayed(const Duration(seconds: 2));
            await _attemptCheckParticipation();
            return;
          }

          setState(() {
            _isLoading = false;
            _serverError = 'server_unreachable'.tr;
          });
          return;
        }

        // ✅ Normaliser la réponse
        final normalized =
            _normalizeParticipationResponse(Map<String, dynamic>.from(result));

        if (normalized == null) {
          if (_cachedParticipationId != null) {
            await _clearParticipationData();
          }
          setState(() {
            _currentParticipationData = null;
            _isLoading = false;
            _serverError = null;
            _ficheCreated = false;
          });
          return;
        }

        final String participationId = normalized['idParticipation'];

        // ✅ Check if it's a new participation
        final bool isNewOuting = _cachedParticipationId != participationId;
        print('🔍 Cached: $_cachedParticipationId | New: $participationId | Is New: $isNewOuting');

        // ✅ Save data to cache
        await _saveParticipationData(normalized, participationId);
        _currentParticipationData = normalized;

        // ✅ If new participation, create source and fiche
        if (isNewOuting) {
          print('🆕 New participation detected, creating source and fiche...');
          await _createSourceAndFiche(normalized);
          _showNewParticipationNotification(normalized);
        }

        setState(() {
          _isLoading = false;
          _serverError = null;
        });
        return;
      }

      // ✅ If result is null (network error)
      if (_retryCount < _maxRetries) {
        await Future.delayed(const Duration(seconds: 2));
        await _attemptCheckParticipation();
        return;
      }

      setState(() {
        _isLoading = false;
        _serverError = 'server_unreachable'.tr;
      });
    } catch (e) {
      print('❌ Error in _attemptCheckParticipation: $e');
      if (_retryCount < _maxRetries) {
        await Future.delayed(const Duration(seconds: 2));
        await _attemptCheckParticipation();
        return;
      }

      setState(() {
        _isLoading = false;
        _serverError = 'server_unreachable'.tr;
      });
    }
  }

  // ✅ Save participation data to cache
  Future<void> _saveParticipationData(
      Map<String, dynamic> data, String participationId) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.saveParticipationId(participationId);
    await authProvider.saveParticipationData(data);
    _cachedParticipationId = participationId;
    _currentParticipationData = data;
    print('💾 Participation data saved to cache: $participationId');
  }

  // ✅ Clear participation data from cache
  Future<void> _clearParticipationData() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.clearParticipationId();
    _cachedParticipationId = null;
    _currentParticipationData = null;
    _ficheCreated = false;
    print('🗑️ Participation data cleared from cache');
  }

  // ✅ Show notification for new participation
  void _showNewParticipationNotification(Map<String, dynamic> data) {
    final zoneDetail = data['zone_detail'];
    final location = zoneDetail?['ville'] ?? 'N/A';
    final date = data['dateSortie'] ?? 'N/A';
    final time = _formatTime(data['dateSortie'] ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Text(
              'new_participation_assigned'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📍 $location',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '📅 $date',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '🕐 $time',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'new_outing_assigned'.tr,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_ficheCreated) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note_add_outlined, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'fiche_auto_created'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'ok'.tr,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Refresh participation check
  Future<void> _refreshParticipation() async {
    setState(() => _isRefreshing = true);
    _retryCount = 0;
    await _attemptCheckParticipation();
    setState(() => _isRefreshing = false);
  }

  // ✅ Helper methods
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateTimeStr);
      return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatTime(String dateTimeStr) {
    try {
      if (dateTimeStr.isEmpty) return 'N/A';
      final date = DateTime.parse(dateTimeStr);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
            )
          : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      foregroundColor: Colors.white,
      title: Text(
        'my_participations'.tr,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      actions: [
        _isRefreshing
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _refreshParticipation,
              ),
      ],
    );
  }

  Widget _buildContent() {
    if (_serverError != null) {
      return _buildServerUnreachable();
    }

    if (_currentParticipationData != null) {
      return _buildParticipationCard();
    }
    return _buildEmptyState();
  }

  Widget _buildServerUnreachable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_outlined,
              size: 64,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'server_unreachable'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'server_unreachable_description'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isRefreshing ? null : _refreshParticipation,
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text('retry'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'no_participation_assigned'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'no_participation_scheduled'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isRefreshing ? null : _refreshParticipation,
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text('refresh'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationCard() {
    final data = _currentParticipationData!;
    final zoneDetail = data['zone_detail'] is Map
        ? Map<String, dynamic>.from(data['zone_detail'])
        : null;
    final campagneDetail = data['campagne_detail'] is Map
        ? Map<String, dynamic>.from(data['campagne_detail'])
        : null;
    final etablissementDetail = data['etablissement_detail'] is Map
        ? Map<String, dynamic>.from(data['etablissement_detail'])
        : null;
    final isCurrent = _cachedParticipationId == data['idParticipation'];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: isCurrent
                  ? Border.all(color: AppColors.primaryGreen, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: AppColors.primaryGreen,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCurrent ? 'current_participation'.tr : 'participation'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'active'.tr,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Zone details
                if (zoneDetail != null) ...[
                  _buildSectionLabel('zone_location'.tr, Icons.location_on_outlined),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.location_on,
                    'zone_location'.tr,
                    '${zoneDetail['ville'] ?? 'N/A'} - ${zoneDetail['quartier'] ?? 'N/A'}',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.public,
                    'region'.tr,
                    '${zoneDetail['region'] ?? 'N/A'}, ${zoneDetail['pays'] ?? 'N/A'}',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.route,
                    'route'.tr,
                    '${zoneDetail['lieuDepart'] ?? 'N/A'} → ${zoneDetail['lieuArrivee'] ?? 'N/A'}',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.info_outline,
                    'zone'.tr,
                    zoneDetail['libele'] ?? 'N/A',
                  ),
                  if (zoneDetail['description'] != null &&
                      zoneDetail['description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.description_outlined,
                      'description'.tr,
                      zoneDetail['description'],
                    ),
                  ],
                  const SizedBox(height: 16),
                ],

                // Établissement (le cas échéant)
                if (etablissementDetail != null) ...[
                  _buildSectionLabel('establishment'.tr, Icons.school_outlined),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.school,
                    'establishment'.tr,
                    etablissementDetail['nomEtablissement'] ??
                        etablissementDetail['libele'] ??
                        'N/A',
                  ),
                  const SizedBox(height: 16),
                ],

                // Date & type de la sortie
                _buildInfoRow(
                  Icons.calendar_today,
                  'date'.tr,
                  _formatDateTime(data['dateSortie']),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.category_outlined,
                  'type'.tr,
                  data['typeSortie'] ?? 'N/A',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.info_outline,
                  'status'.tr,
                  data['statut'] ?? 'N/A',
                ),
                const SizedBox(height: 16),

                // Campaign details
                if (campagneDetail != null) ...[
                  _buildSectionLabel('campaign'.tr, Icons.campaign_outlined),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.campaign_outlined,
                    'campaign'.tr,
                    campagneDetail['libele'] ?? 'N/A',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.category,
                    'type'.tr,
                    campagneDetail['type'] ?? 'N/A',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.date_range,
                    'campaign_period'.tr,
                    '${_formatDateTime(campagneDetail['dateDebut'])} → ${_formatDateTime(campagneDetail['dateFin'])}',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.flag_outlined,
                    'objective'.tr,
                    campagneDetail['objectif'] ?? 'N/A',
                  ),
                  if (campagneDetail['description'] != null &&
                      campagneDetail['description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.description_outlined,
                      'description'.tr,
                      campagneDetail['description'],
                    ),
                  ],
                  const SizedBox(height: 16),
                ],

                // Objectif de prospection
                _buildInfoRow(
                  Icons.adjust_rounded,
                  'prospecting_goal'.tr,
                  '${data['objectif'] ?? '0'} prospects',
                ),
                const SizedBox(height: 8),

                // ✅ Fiche created badge
                if (_ficheCreated) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'fiche_auto_created'.tr,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Comment
                if (data['commentaire'] != null && data['commentaire'].toString().isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note_outlined, color: Colors.amber, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            data['commentaire'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ✅ Only Details button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _showParticipationDetails(data);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('details'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primaryGreen),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  void _showParticipationDetails(Map<String, dynamic> data) {
    final zoneDetail = data['zone_detail'] is Map
        ? Map<String, dynamic>.from(data['zone_detail'])
        : null;
    final campagneDetail = data['campagne_detail'] is Map
        ? Map<String, dynamic>.from(data['campagne_detail'])
        : null;
    final etablissementDetail = data['etablissement_detail'] is Map
        ? Map<String, dynamic>.from(data['etablissement_detail'])
        : null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Text(
                      'participation_details'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('type'.tr, data['typeSortie'] ?? 'N/A'),
                _buildDetailRow('status'.tr, data['statut'] ?? 'N/A'),
                _buildDetailRow('date'.tr, _formatDateTime(data['dateSortie'])),
                _buildDetailRow(
                    'prospecting_goal'.tr, '${data['objectif'] ?? '0'} prospects'),
                if (zoneDetail != null) ...[
                  const Divider(height: 20),
                  _buildDetailRow('zone'.tr, zoneDetail['libele'] ?? 'N/A'),
                  _buildDetailRow('location'.tr, zoneDetail['ville'] ?? 'N/A'),
                  _buildDetailRow('quartier'.tr, zoneDetail['quartier'] ?? 'N/A'),
                  _buildDetailRow('region'.tr,
                      '${zoneDetail['region'] ?? 'N/A'}, ${zoneDetail['pays'] ?? 'N/A'}'),
                  _buildDetailRow('route'.tr,
                      '${zoneDetail['lieuDepart'] ?? 'N/A'} → ${zoneDetail['lieuArrivee'] ?? 'N/A'}'),
                  if (zoneDetail['description'] != null &&
                      zoneDetail['description'].toString().isNotEmpty)
                    _buildDetailRow('description'.tr, zoneDetail['description']),
                ],
                if (etablissementDetail != null) ...[
                  const Divider(height: 20),
                  _buildDetailRow(
                    'establishment'.tr,
                    etablissementDetail['nomEtablissement'] ??
                        etablissementDetail['libele'] ??
                        'N/A',
                  ),
                ],
                if (campagneDetail != null) ...[
                  const Divider(height: 20),
                  _buildDetailRow('campaign'.tr, campagneDetail['libele'] ?? 'N/A'),
                  _buildDetailRow('type'.tr, campagneDetail['type'] ?? 'N/A'),
                  _buildDetailRow(
                    'campaign_period'.tr,
                    '${_formatDateTime(campagneDetail['dateDebut'])} → ${_formatDateTime(campagneDetail['dateFin'])}',
                  ),
                  _buildDetailRow('objective'.tr, campagneDetail['objectif'] ?? 'N/A'),
                  if (campagneDetail['description'] != null &&
                      campagneDetail['description'].toString().isNotEmpty)
                    _buildDetailRow('description'.tr, campagneDetail['description']),
                ],
                if (data['commentaire'] != null &&
                    data['commentaire'].toString().isNotEmpty) ...[
                  const Divider(height: 20),
                  _buildDetailRow('comment'.tr, data['commentaire']),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('close'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}