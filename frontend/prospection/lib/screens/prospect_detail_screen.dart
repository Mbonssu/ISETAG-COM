import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/themes/glass_theme.dart';
import '../models/prospectData.dart';
import '../services/translation_service.dart';

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

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 2, vsync: this);
    // _tc = TabController(length: 3, vsync: this);
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
                  // _buildHistoriqueTab()
                ],
              ),
            ),
            // _buildActionBar(),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              _headerIconBtn(Icons.more_vert),
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
              // Tab(text: 'history_tab'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    final rows = [
      (
        Icons.sensors_rounded,
        'source'.tr,
        prospect.prosp.source_infos,
        false
      ),
      (
        Icons.school_outlined,
        'establishment'.tr,
        prospect.etablissement,
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
      default:
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
                  Text(name,
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
            // const Icon(Icons.chevron_right, color: G.textLight),
          ]),
        ),
      ),
    );
  }

  Widget _buildHistoriqueTab() {
    final items = [
      ('15 Jan 2025', 'first_contact'.tr, 'phone_call'.tr),
      ('20 Jan 2025', 'visit_done'.tr, 'visit_location'.tr),
      ('25 Jan 2025', 'followup_scheduled'.tr, 'followup_reason'.tr),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        final isLast = i == items.length - 1;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(
              width: 12,
              height: 12,
              decoration:
                  const BoxDecoration(color: G.green, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(
                  width: 2,
                  height: 62,
                  color: Colors.black.withValues(alpha: 0.08)),
          ]),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GlassBox(
                borderRadius: 12,
                bgColor: G.glassCard,
                borderColor: G.glassBorder,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$1,
                          style: const TextStyle(
                              fontSize: 10, color: G.textLight)),
                      const SizedBox(height: 3),
                      Text(item.$2,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: G.textDark)),
                      const SizedBox(height: 2),
                      Text(item.$3,
                          style: const TextStyle(
                              fontSize: 11, color: G.textMedium)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }

  Widget _buildActionBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          color: G.glassCard,
          padding: EdgeInsets.fromLTRB(
            14,
            11,
            14,
            MediaQuery.of(context).padding.bottom + 11,
          ),
          child: Row(children: [
            Expanded(
              child: GlassBox(
                height: 48,
                borderRadius: 13,
                bgColor: G.green.withValues(alpha: 0.10),
                borderColor: G.btnOutlineBorder,
                onTap: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_outlined, color: G.green, size: 18),
                    SizedBox(width: 7),
                    Text('call',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: G.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: GlassBox(
                height: 48,
                borderRadius: 13,
                bgColor: G.btnPrimaryBg,
                borderColor: G.btnPrimaryBorder,
                shadows: [
                  BoxShadow(
                    color: G.green.withValues(alpha: 0.38),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                onTap: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        color: Colors.white, size: 18),
                    SizedBox(width: 7),
                    Text('whatsapp',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
