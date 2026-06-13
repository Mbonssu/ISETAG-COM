import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import 'package:isetagcom/routes/app_router.dart';
import '../utils/themes/app_colors.dart';
// import 'fiche_detail_screen.dart';

class FicheListScreen extends StatelessWidget {
  FicheListScreen({super.key});

  int totalProspects = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: StreamBuilder<List<Fiche>>(
              stream: LocalStorage.instance.watchAllFiches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                final fiches = snapshot.data ?? [];


                if (fiches.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildFicheList(fiches, isSmallScreen, context);
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: _buildFab(isSmallScreen),
    );
  }

  Widget _buildHeader(BuildContext ctx) {
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
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Mes fiches',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFicheList(
      List<Fiche> fiches, bool isSmallScreen, BuildContext context) {
    totalProspects = fiches.fold(0, (sum, f) => sum + f.prospects.length);
    print("All Prospects $totalProspects");

    return Column(
      children: [
        _buildStatsHeader(fiches.length, totalProspects),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fiches.length,
            itemBuilder: (ctx, index) =>
                _buildFicheCard(fiches[index], isSmallScreen, ctx),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader(int fichesCount, int prospectsCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.folder_outlined,
            label: 'Fiches',
            value: fichesCount.toString(),
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            icon: Icons.people_outline,
            label: 'Prospects',
            value: prospectsCount.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.lightShadow,
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.primaryGreen),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFicheCard(
      Fiche fiche, bool isSmallScreen, BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(fiche.dateCollecte);
    final time = DateFormat('HH:mm').format(fiche.dateCollecte);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.ficheDetail,
            arguments: {'ficheId': fiche.idFiche},
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.folder,
                      color: AppColors.primaryGreen, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.people_outline,
                              size: 14, color: AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            '$totalProspects prospects',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textTertiary),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star,
                              size: 14, color: AppColors.starYellow),
                          const SizedBox(width: 4),
                          Text(
                            '${fiche.scoreInteret}/10',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen),
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Aucune fiche',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'Commencez par créer une nouvelle fiche',
            style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildFab(bool isSmallScreen) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.primaryGreen,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
