import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/themes/glass_theme.dart';
import 'prospect_detail_screen.dart';
import '../models/prospect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          bottom: false,
          child: Column(children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ]),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // ── Header vert glass ──────────────────────────────────────────────────────
  Widget _buildHeader() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          decoration: const BoxDecoration(
            color: G.headerBg,
            border: Border(bottom: BorderSide(color: G.headerBorder)),
          ),
          child: Column(children: [
            // Greeting + avatar + cloche
            Row(children: [
              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bonjour,',
                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                  SizedBox(height: 1),
                  Text('Jean M.',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ],
              )),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white54, width: 1.5),
                  color: Colors.white24,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              // Cloche avec badge
              Stack(clipBehavior: Clip.none, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: G.white18,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: const Icon(Icons.notifications_none_outlined,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                        color: Color(0xFFE65100), shape: BoxShape.circle),
                    child: const Center(
                        child: Text('3',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800))),
                  ),
                ),
              ]),
            ]),
            const SizedBox(height: 12),
            // Search bar
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: Colors.white38),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(children: [
                    const Icon(Icons.search, color: Colors.white60, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                        child: Text('Rechercher un prospect...',
                            style: TextStyle(
                                color: Colors.white60, fontSize: 12))),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: G.white15,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.tune_outlined,
                          color: Colors.white, size: 16),
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

  // ── Corps scrollable ───────────────────────────────────────────────────────
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Aperçu aujourd\'hui',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: G.textDark)),
        const SizedBox(height: 10),
        _buildStatsGrid(),
        const SizedBox(height: 18),
        const Row(children: [
          Expanded(
              child: Text('Prospections récentes',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: G.textDark))),
          Text('Voir tout',
              style: TextStyle(
                  fontSize: 12, color: G.green, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        ...kProspects.map((p) => _buildProspectCard(p)),
        const SizedBox(height: 80),
      ]),
    );
  }

  // ── Grille statistiques ────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    final stats = [
      (Icons.people_outline, '12', 'Prospects ajoutés', G.green),
      (Icons.assignment_outlined, '05', 'À relancer', const Color(0xFFB8860B)),
      (Icons.directions_walk_outlined, '08', 'Visites effectuées', G.green),
      (Icons.person_add_outlined, '02', 'Nouveaux établis.', G.green),
    ];
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.75,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: stats
          .map((s) => GlassBox(
                borderRadius: 13,
                bgColor: G.glassStat,
                borderColor: G.glassBorder,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                  child: Row(children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: s.$4.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: s.$4.withValues(alpha: 0.22)),
                      ),
                      child: Icon(s.$1, color: s.$4, size: 19),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.$2,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: G.textDark)),
                        Text(s.$3,
                            style: const TextStyle(
                                fontSize: 10, color: G.textMedium, height: 1.3),
                            maxLines: 2),
                      ],
                    )),
                  ]),
                ),
              ))
          .toList(),
    );
  }

  // ── Carte prospect ─────────────────────────────────────────────────────────
  Widget _buildProspectCard(ProspectData p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: GlassBox(
        borderRadius: 13,
        bgColor: G.glassCard,
        borderColor: G.glassBorder,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProspectDetailScreen(prospect: p))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(children: [
            // Avatar initiales
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(p.color).withValues(alpha: 0.80),
                    Color(p.color).withValues(alpha: 0.55),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Color(p.color).withValues(alpha: 0.40)),
              ),
              child: Center(
                  child: Text(p.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13))),
            ),
            const SizedBox(width: 11),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: G.textDark)),
                const SizedBox(height: 1),
                Text(p.institution,
                    style: const TextStyle(fontSize: 11, color: G.textMedium)),
                const SizedBox(height: 1),
                Text(p.interest,
                    style: const TextStyle(fontSize: 10, color: G.textLight)),
              ],
            )),
            StatusBadge(status: p.status.name),
            const SizedBox(width: 6),
            const Icon(Icons.more_vert, color: G.textLight, size: 18),
          ]),
        ),
      ),
    );
  }

  // ── Bottom nav glass ───────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      (Icons.home_outlined, Icons.home, 'Accueil', null),
      (Icons.people_outline, Icons.people, 'Prospects', null),
      (Icons.access_time_outlined, Icons.access_time, 'Relances', 2),
      (Icons.person_outline, Icons.person, 'Profil', null),
    ];
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.651),
            border: Border(top: BorderSide(color: G.navBorder, width: 1)),
          ),
          child: Row(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final active = _tab == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tab = i),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Stack(clipBehavior: Clip.none, children: [
                        Icon(active ? item.$2 : item.$1,
                            color: active ? G.green : G.textLight, size: 22),
                        if (item.$4 != null)
                          Positioned(
                            top: -5,
                            right: -8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFE65100),
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Text('${item.$4}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800))),
                            ),
                          ),
                      ]),
                      const SizedBox(height: 3),
                      Text(item.$3,
                          style: TextStyle(
                              fontSize: 10,
                              color: active ? G.green : G.textLight,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w400)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────
  Widget _buildFab() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GlassBox(
        borderRadius: 28,
        width: 52,
        height: 52,
        bgColor: G.btnPrimaryBg,
        borderColor: G.btnPrimaryBorder,
        shadows: [
          BoxShadow(
              color: G.green.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
        onTap: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}
