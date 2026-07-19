// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import 'package:isetagcom/models/prospectData.dart';
import '../models/classe.dart';
import '../models/etablissement.dart';
import '../models/interet_filiere.dart';
import '../models/pros.dart';
import '../models/specialite.dart';
import '../services/notification_service.dart';
import '../services/translation_service.dart';
import '../utils/status.dart';
import '../utils/themes/app_colors.dart';
import 'prospect_detail_screen.dart';

class RelancesScreen extends StatefulWidget {
  const RelancesScreen({super.key});

  @override
  State<RelancesScreen> createState() => _RelancesScreenState();
}

class _RelancesScreenState extends State<RelancesScreen> {
  // ✅ Pagination
  static const int _pageSize = 20;
  int _currentPage = 0;
  bool _isLoading = true;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  List<ProspectDetails> _allProspects = [];
  List<ProspectDetails> _filteredProspects = [];

  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _filterType = 'all';

  final Map<String, String> _filterOptions = {
    'all': 'all'.tr,
    'today': 'today'.tr,
    'week': 'this_week'.tr,
    'month': 'this_month'.tr,
    'overdue': 'overdue'.tr,
  };

  final List<Map<String, dynamic>> _appNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadRelances();
    _initNotificationService();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _initNotificationService() async {
    await NotificationService.instance.initialize();
  }

  Future<void> _loadRelances() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _allProspects = [];
      _filteredProspects = [];
      _hasMoreData = true;
    });

    await _loadProspects();
    setState(() => _isLoading = false);
  }

  Future<void> _loadProspects() async {
    if (!_hasMoreData || _isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final newProspects = await _getPaginatedRelances(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (newProspects.isEmpty) {
        setState(() => _hasMoreData = false);
      } else {
        setState(() {
          _allProspects.addAll(newProspects);
          _currentPage++;
          _applyFilters();
        });
      }
    } catch (e) {
      print('Error loading relances: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<List<ProspectDetails>> _getPaginatedRelances({
    required int page,
    required int pageSize,
  }) async {
    final localStorage = LocalStorage.instance;
    final isar = localStorage.isar;

    final now = DateTime.now();

    final prospects = await isar.prospects
        .where()
        .filter()
        .date_relanceIsNotNull()
        .offset(page * pageSize)
        .limit(pageSize)
        .findAll();

    if (prospects.isEmpty) return [];

    prospects.sort((a, b) => a.date_relance!.compareTo(b.date_relance!));

    final prospectIds = prospects.map((p) => p.idProspect).toList();

    final allInterets = await isar.interetFilieres
        .where()
        .filter()
        .anyOf(prospectIds, (q, id) => q.idProspectEqualTo(id))
        .findAll();

    final specialiteIds = allInterets.map((i) => i.idSpecialite).toList();
    final allSpecialites = specialiteIds.isNotEmpty
        ? await isar.specialites
            .where()
            .anyOf(specialiteIds, (q, id) => q.idSpecialiteEqualTo(id))
            .findAll()
        : [];

    final specialiteMap = {for (var s in allSpecialites) s.idSpecialite: s};

    final classeIds = prospects.map((p) => p.idClass).toList();
    final allClasses = await isar.classes
        .where()
        .anyOf(classeIds, (q, id) => q.idClasseEqualTo(id))
        .findAll();

    final classeMap = {for (var c in allClasses) c.idClasse: c};

    final etsIds = allClasses.map((c) => c.idEts).toList();
    final allEts = await isar.etablissements
        .where()
        .anyOf(etsIds, (q, id) => q.idEtablissementEqualTo(id))
        .findAll();

    final etsMap = {for (var e in allEts) e.idEtablissement: e};

    final detailsList = <ProspectDetails>[];
    for (final prospect in prospects) {
      final interets = allInterets
          .where((i) => i.idProspect == prospect.idProspect)
          .toList();
      final specialities = interets
          .map((i) {
            final spec = specialiteMap[i.idSpecialite];
            return spec != null
                ? SpecialityDetail(
                    libelleSpecialite: spec.libelleSpecialite,
                    orderPreference: i.ordrePreference,
                    niveau: i.niveauInteret,
                    commentaire: i.commentaire ?? '',
                  )
                : null;
          })
          .whereType<SpecialityDetail>()
          .toList()
        ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));

      final classe = classeMap[prospect.idClass];
      final ets = classe != null ? etsMap[classe.idEts] : null;

      detailsList.add(ProspectDetails(
        prosp: prospect,
        etablissement: ets ??
            Etablissement(
              idEtablissement: '',
              nomEtablissement: 'Non spécifié',
              typeEtablissement: '',
              createdAt: DateTime.now(),
              syncState: SyncState.pending,
            ),
        classe: classe ??
            Classe(
              idClasse: '',
              idEts: '',
              libelleClasse: 'Non spécifié',
              createdAt: DateTime.now(),
              syncState: SyncState.pending,
            ),
        specialities: specialities,
      ));
    }

    return detailsList;
  }

  void _loadMoreData() {
    if (!_hasMoreData || _isLoadingMore) return;
    _loadProspects();
  }

  void _applyFilters() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    _filteredProspects = _allProspects.where((p) {
      final dateRelance = p.prosp.date_relance!;

      switch (_filterType) {
        case 'today':
          return dateRelance.year == now.year &&
              dateRelance.month == now.month &&
              dateRelance.day == now.day;
        case 'week':
          return dateRelance.isAfter(startOfWeek) &&
              dateRelance.isBefore(endOfWeek);
        case 'month':
          return dateRelance.year == now.year && dateRelance.month == now.month;
        case 'overdue':
          return dateRelance.isBefore(now);
        default:
          return true;
      }
    }).toList();

    if (_searchQuery.isNotEmpty) {
      _filteredProspects = _filteredProspects.where((p) {
        return p.prosp.nomComplet
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            p.etablissement.nomEtablissement
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    _filteredProspects
        .sort((a, b) => a.prosp.date_relance!.compareTo(b.prosp.date_relance!));
  }

  Future<void> _markAsDone(ProspectDetails prospect) async {
    prospect.prosp.prospectStatus = ProspectStatus.contacte;
    prospect.prosp.date_relance = null;

    await LocalStorage.instance.saveProspect(prospect.prosp);
    await NotificationService.instance
        .cancelReminder(prospect.prosp.idProspect);

    setState(() {
      _allProspects
          .removeWhere((p) => p.prosp.idProspect == prospect.prosp.idProspect);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Relance marquée comme terminée'.tr),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _postponeRelance(ProspectDetails prospect, int days) async {
    final newDate = DateTime.now().add(Duration(days: days));

    prospect.prosp.date_relance = newDate;
    prospect.prosp.prospectStatus = ProspectStatus.relancer;

    await LocalStorage.instance.saveProspect(prospect.prosp);
    await NotificationService.instance
        .cancelReminder(prospect.prosp.idProspect);
    await NotificationService.instance.scheduleReminder(
      prospectId: prospect.prosp.idProspect,
      prospectName: prospect.prosp.nomComplet,
      date: newDate,
      comment: 'Relance reportée de $days jour(s)',
    );

    setState(() => _applyFilters());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⏰ Relance reportée de $days jour(s)'.tr),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _scheduleCustomRelance(
      ProspectDetails prospect, DateTime dateTime) async {
    prospect.prosp.date_relance = dateTime;
    prospect.prosp.prospectStatus = ProspectStatus.relancer;

    await LocalStorage.instance.saveProspect(prospect.prosp);
    await NotificationService.instance.scheduleReminder(
      prospectId: prospect.prosp.idProspect,
      prospectName: prospect.prosp.nomComplet,
      date: dateTime,
      comment: 'Relance programmée manuellement',
    );

    setState(() => _applyFilters());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '📅 Relance programmée pour ${DateFormat('dd/MM/yyyy HH:mm').format(dateTime)}'
                .tr),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showScheduleDialog(ProspectDetails prospect) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('📅 Programmer une relance'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.calendar_today,
                      size: 20, color: AppColors.primaryGreen),
                  title: Text(
                    'Date : ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.access_time,
                      size: 20, color: AppColors.primaryGreen),
                  title: Text(
                    'Heure : ${selectedTime.format(context)}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickDateChip(context, '+1 jour', () {
                      setState(() {
                        selectedDate =
                            DateTime.now().add(const Duration(days: 1));
                      });
                    }),
                    _buildQuickDateChip(context, '+3 jours', () {
                      setState(() {
                        selectedDate =
                            DateTime.now().add(const Duration(days: 3));
                      });
                    }),
                    _buildQuickDateChip(context, '+1 semaine', () {
                      setState(() {
                        selectedDate =
                            DateTime.now().add(const Duration(days: 7));
                      });
                    }),
                    _buildQuickDateChip(context, '+2 semaines', () {
                      setState(() {
                        selectedDate =
                            DateTime.now().add(const Duration(days: 14));
                      });
                    }),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'.tr),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  Navigator.pop(context);
                  _scheduleCustomRelance(prospect, scheduledDateTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Programmer'.tr),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickDateChip(
      BuildContext context, String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: Colors.grey.shade300),
    );
  }

  void _showNotificationsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'notifications'.tr,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_appNotifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('no_notifications'.tr),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _appNotifications.length,
                    itemBuilder: (context, index) {
                      final notif = _appNotifications[index];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          notif['read']
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: notif['read'] ? Colors.grey : Colors.orange,
                          size: 20,
                        ),
                        title: Text(
                          notif['title'],
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          notif['body'],
                          style: const TextStyle(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          DateFormat('dd/MM/yy').format(notif['date']),
                          style: const TextStyle(fontSize: 10),
                        ),
                        onTap: () {
                          setState(() {
                            notif['read'] = true;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(),
          _buildNotificationBell(),
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProspects.isEmpty
                    ? _buildEmptyState()
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(12),
                              itemCount: _filteredProspects.length,
                              itemBuilder: (context, index) {
                                final prospect = _filteredProspects[index];
                                return _buildCompactRelanceCard(
                                  prospect,
                                  isSmallScreen,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'follow_ups'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_filteredProspects.length}',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    final unreadCount = _appNotifications.where((n) => !n['read']).length;

    return Container(
      margin: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => _showNotificationsDialog(),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.lightShadow,
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_outlined,
                  color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'notifications'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unreadCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applyFilters();
          });
        },
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _applyFilters();
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _filterOptions.entries.map((entry) {
          final isSelected = _filterType == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _filterType = entry.key;
                  _applyFilters();
                });
              },
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompactRelanceCard(
      ProspectDetails prospect, bool isSmallScreen) {
    final dateRelance = prospect.prosp.date_relance!;
    final isOverdue = dateRelance.isBefore(DateTime.now());
    final dateFormatted = DateFormat('dd/MM/yyyy').format(dateRelance);
    final timeFormatted = DateFormat('HH:mm').format(dateRelance);
    final dayDifference = DateTime.now().difference(dateRelance).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isOverdue
            ? Border.all(color: Colors.red.shade300, width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProspectDetailScreen(prospect: prospect),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isOverdue ? Colors.red : AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(prospect.color).withOpacity(0.8),
                        Color(prospect.color).withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      prospect.prosp.nomComplet.isNotEmpty
                          ? prospect.prosp.nomComplet[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              prospect.prosp.nomComplet,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isOverdue)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    size: 12,
                                    color: Colors.red.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${dayDifference}j',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              prospect.etablissement.nomEtablissement,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 11,
                            color: isOverdue
                                ? Colors.red.shade400
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormatted,
                            style: TextStyle(
                              fontSize: 10,
                              color: isOverdue
                                  ? Colors.red.shade400
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time,
                            size: 11,
                            color: isOverdue
                                ? Colors.red.shade400
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeFormatted,
                            style: TextStyle(
                              fontSize: 10,
                              color: isOverdue
                                  ? Colors.red.shade400
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasOverdue = _allProspects.any((p) =>
        p.prosp.date_relance != null &&
        p.prosp.date_relance!.isBefore(DateTime.now()));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasOverdue
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            size: 70,
            color: hasOverdue ? Colors.orange.shade300 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            hasOverdue ? 'overdue_relances'.tr : 'no_followups'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasOverdue ? 'check_overdue_relances'.tr : 'up_to_date'.tr,
            style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
          if (hasOverdue) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterType = 'overdue';
                  _applyFilters();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('show_overdue'.tr),
            ),
          ],
        ],
      ),
    );
  }
}
