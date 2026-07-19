// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import '../utils/themes/glass_theme.dart';
import '../models/prospectData.dart';
import '../services/translation_service.dart';
import '../screens/add_prospect_screen.dart';

class ProspectDetailScreen extends StatefulWidget {
  final ProspectDetails prospect;
  const ProspectDetailScreen({super.key, required this.prospect});

  @override
  State<ProspectDetailScreen> createState() => _DetailState();
}

class _DetailState extends State<ProspectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tc;
  ProspectDetails get prospect => widget.prospect;
  
  // ✅ Variable pour suivre le numéro sélectionné
  String? _selectedPhoneNumber;

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 2, vsync: this);
    _test();
    // ✅ Initialiser avec le numéro du prospect par défaut
    _selectedPhoneNumber = prospect.prosp.telephone;
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          bottom: false,
          child: Column(children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tc,
                children: [
                  _buildInfoTab(),
                  _buildFiliereTab(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // ✅ Vérifier si la date de relance est arrivée ou dépassée
    final bool isRelanceDue = prospect.prosp.date_relance != null &&
        prospect.prosp.date_relance!.isBefore(DateTime.now());

    // ✅ Récupérer les numéros disponibles
    final List<Map<String, String>> phoneOptions = [];
    
    // Ajouter le numéro du prospect
    phoneOptions.add({
      'label': 'Prospect: ${prospect.prosp.telephone}',
      'number': prospect.prosp.telephone,
    });
    
    // Ajouter le numéro du parent s'il existe et est différent
    if (prospect.prosp.telephoneParent.isNotEmpty &&
        prospect.prosp.telephoneParent != prospect.prosp.telephone) {
      phoneOptions.add({
        'label': 'Parent: ${prospect.prosp.telephoneParent}',
        'number': prospect.prosp.telephoneParent,
      });
    }

    // ✅ Si le numéro sélectionné n'est plus dans la liste, réinitialiser
    if (_selectedPhoneNumber != null &&
        !phoneOptions.any((opt) => opt['number'] == _selectedPhoneNumber)) {
      _selectedPhoneNumber = phoneOptions.isNotEmpty ? phoneOptions[0]['number'] : null;
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          decoration: const BoxDecoration(
            color: G.headerBg,
            border: Border(bottom: BorderSide(color: G.headerBorder)),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Column(children: [
            Row(children: [
              _headerIconBtn(Icons.arrow_back,
                  onTap: () => Navigator.of(context).pop()),
              Expanded(
                child: Text(
                  'prospect_details'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              _headerIconBtn(Icons.edit_outlined,
                  onTap: () => _navigateToEditScreen()),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: G.white18,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: G.yellow.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: G.yellow.withValues(alpha: 0.45)),
                      ),
                      child: Center(
                        child: Text(
                          prospect.prosp.nomComplet[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black26)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                              prospect.prosp.nomComplet,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: G.badgeYellowBg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: G.badgeYellowBdr),
                                  ),
                                  child: Text(
                                    _getStatusTranslation(
                                        prospect.prosp.prospectStatus.name),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: G.badgeYellowText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 6),
                          _contactRow(
                              Icons.phone_outlined, prospect.prosp.telephone),
                          const SizedBox(height: 3),
                          _contactRow(
                            Icons.email_outlined,
                            prospect.prosp.email ?? 'no_email'.tr,
                          ),
                          // ✅ Ajout du dropdown et du bouton d'appel si la relance est due
                          if (isRelanceDue) ...[
                            const SizedBox(height: 8),
                            _buildCallSection(phoneOptions),
                          ],
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ✅ Section d'appel avec dropdown
  Widget _buildCallSection(List<Map<String, String>> phoneOptions) {
    return Row(
      children: [
        // ✅ Dropdown pour choisir le numéro
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPhoneNumber,
                dropdownColor: const Color(0xFF1A1A2E),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                isExpanded: true,
                items: phoneOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['number'],
                    child: Text(
                      option['label']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPhoneNumber = value;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // ✅ Bouton d'appel
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => _makePhoneCall(_selectedPhoneNumber ?? prospect.prosp.telephone),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Appeler'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Méthode pour lancer un appel téléphonique
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      _showSnackBar('Aucun numéro de téléphone disponible', Colors.orange);
      return;
    }

    // Nettoyer le numéro de téléphone
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Formater le numéro
    String formattedPhone = cleanPhone;
    if (cleanPhone.startsWith(RegExp(r'^[625]')) && cleanPhone.length == 9) {
      formattedPhone = '+237$cleanPhone';
    }
    
    final Uri telUri = Uri(scheme: 'tel', path: formattedPhone);
    
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        _showSnackBar('Impossible de lancer l\'appel', Colors.red);
      }
    } catch (e) {
      print('❌ Erreur lors de l\'appel: $e');
      _showSnackBar('Erreur: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ✅ Navigate to edit screen
  void _navigateToEditScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProspectScreen(
          prospectToEdit: widget.prospect.prosp,
          prospectDetails: widget.prospect,
        ),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {});
      }
    });
  }

  String _getStatusTranslation(String status) {
    switch (status.toLowerCase()) {
      case 'relancer':
        return 'to_relaunch_badge'.tr;
      case 'nouveau':
        return 'new_badge'.tr;
      case 'contacte':
        return 'contacted_badge'.tr;
      default:
        return status;
    }
  }

  Widget _headerIconBtn(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: G.white18,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white30),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(children: [
      Icon(icon, color: Colors.white60, size: 14),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
    ]);
  }

  Widget _buildTabBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          color: G.glassCard,
          child: TabBar(
            controller: _tc,
            labelColor: G.green,
            unselectedLabelColor: G.textLight,
            indicatorColor: G.green,
            indicatorWeight: 2.5,
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            tabs: [
              Tab(text: 'information_tab'.tr),
              Tab(text: 'specialties_tab'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    final rows = [
      (Icons.sensors_rounded, 'source'.tr, prospect.prosp.source_infos, false),
      (
        Icons.school_outlined,
        'establishment'.tr,
        prospect.etablissement.nomEtablissement,
        false
      ),
      (
        Icons.class_outlined,
        'current_study_level'.tr,
        prospect.prosp.niveauEtude == 'Baccalauréat'
            ? prospect.classe.libelleClasse.tr
            : prospect.prosp.niveauEtude,
        false
      ),
      (
        Icons.location_on_outlined,
        'address'.tr,
        prospect.prosp.adresse ?? 'no_address'.tr,
        false
      ),
      (
        Icons.people_outline,
        'concerned'.tr,
        prospect.prosp.typeProspect,
        false
      ),
      (Icons.man, 'gender'.tr, prospect.prosp.sexe, false),
      (Icons.man, 'name_par'.tr, prospect.prosp.nomParent, false),
      (
        Icons.phone_in_talk_outlined,
        'phone_par'.tr,
        prospect.prosp.telephoneParent,
        false
      ),
      (
        Icons.edit_outlined,
        'comment'.tr,
        prospect.prosp.commentaireGen ?? 'no_comment'.tr,
        false
      ),
      (
        Icons.calendar_today_outlined,
        'proposed_followup_date'.tr,
        prospect.prosp.date_relance != null
            ? _formatDate(prospect.prosp.date_relance!)
            : 'no_date_scheduled'.tr,
        true
      ),
      (
        prospect.prosp.syncState.name == "pending"
            ? Icons.sync_disabled
            : prospect.prosp.syncState.name == "toUpdate"
                ? Icons.sync_problem_rounded
                : Icons.sync,
        'sync_status'.tr,
        _getSyncStatusTranslation(prospect.prosp.syncState.name),
        true
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: GlassBox(
        borderRadius: 15,
        bgColor: G.glassCard,
        borderColor: G.glassBorder,
        child: Column(
          children: rows.asMap().entries.map((e) {
            final isLast = e.key == rows.length - 1;
            final r = e.value;
            return Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: Colors.black.withValues(alpha: 0.07)),
                      ),
                      child: Icon(r.$1, color: G.textMedium, size: 17),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.$2,
                              style: const TextStyle(
                                  fontSize: 10, color: G.textLight)),
                          const SizedBox(height: 3),
                          Text(
                            r.$3.toString(),
                            style: TextStyle(
                              fontSize: r.$4 ? 14 : 13,
                              fontWeight:
                                  r.$4 ? FontWeight.w800 : FontWeight.w500,
                              color: r.$4 ? G.green : G.textDark,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  height: 1,
                  color: G.glassDivider,
                  margin: const EdgeInsets.symmetric(horizontal: 13),
                ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final f = 'at'.tr;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} $f ${date.hour.toString()}:${date.minute}';
  }

  String _getSyncStatusTranslation(String status) {
    switch (status.toLowerCase()) {
      case 'synced':
        return 'synced'.tr;
      case 'pending':
        return 'sync_pending'.tr;
      case 'failed':
        return 'sync_failed'.tr;
      case 'toupdate':
      case 'toUpdate':
        print("Debug: Sync status is 'toUpdate'");
        return 'sync_to_update'.tr;
      default:
        print('⚠️ Unknown sync status: "$status"');
        return status;
    }
  }

  Widget _buildFiliereTab() {
    final specs = prospect.specialities;

    if (specs.isEmpty) {
      return Center(child: Text('no_specialties'.tr));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: specs.length,
      itemBuilder: (_, i) {
        final spec = specs[i];
        return _filiereCard(
          spec.libelleSpecialite,
          prospect.prosp.niveauEtude,
          spec.commentaire ?? '',
        );
      },
    );
  }

  Widget _filiereCard(String name, String level, String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassBox(
        borderRadius: 13,
        bgColor: G.glassCard,
        borderColor: G.glassBorder,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: G.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: G.green.withValues(alpha: 0.2)),
              ),
              child:
                  const Icon(Icons.school_outlined, color: G.green, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: G.textDark)),
                  const SizedBox(height: 2),
                  Text(level,
                      style: const TextStyle(
                          fontSize: 12,
                          color: G.green,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 1),
                  Text(note,
                      style: const TextStyle(fontSize: 11, color: G.textLight)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _test() {
    print('🔍 Prospect ID: ${prospect.prosp.idProspect}');
    print('🔍 Prospect Name: ${prospect.prosp.nomComplet}');
    print('🔍 SyncState name: ${prospect.prosp.syncState.name}');
    print('🔍 Number of interests: ${prospect.specialities.length}');

    for (var spec in prospect.specialities) {
      print('   - ${spec.libelleSpecialite} (ordre: ${spec.orderPreference})');
    }
  }
}