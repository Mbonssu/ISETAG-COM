// lib/screens/fiche_detail_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import '../models/prospectData.dart';
import '../utils/themes/app_colors.dart';
import 'prospect_detail_screen.dart';

class FicheDetailScreen extends StatefulWidget {
  final String ficheId;
  const FicheDetailScreen({super.key, required this.ficheId});

  @override
  State<FicheDetailScreen> createState() => _FicheDetailScreenState();
}

class _FicheDetailScreenState extends State<FicheDetailScreen> {
  late BuildContext _globalContext;
  List<ProspectDetails> prospectsDetails = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _globalContext = context;
  }

  @override
  Widget build(BuildContext context) {
    _globalContext = context;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: StreamBuilder<Fiche?>(
        stream: LocalStorage.instance.watchFicheWithDetails(widget.ficheId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final fiche = snapshot.data;
          if (fiche == null) {
            return _buildNotFound();
          }

          return _buildContent(fiche);
        },
      ),
    );
  }

  Widget _buildContent(Fiche fiche) {
    return Column(
      children: [
        _buildHeader(fiche),
        Expanded(
          child: StreamBuilder<List<ProspectDetails>>(
            stream: LocalStorage.instance
                .watchProspectsDetailsByFiche(fiche.idFiche),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              prospectsDetails = snapshot.data ?? [];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFicheInfo(fiche),
                    const SizedBox(height: 16),
                    _buildProspectsList(prospectsDetails),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Fiche fiche) {
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
              onTap: () => Navigator.pop(_globalContext),
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Détail de la fiche',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(fiche.dateCollecte),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {},
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'export_pdf', child: Text('Exporter en PDF')),
                const PopupMenuItem(
                    value: 'export_excel', child: Text('Exporter en Excel')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFicheInfo(Fiche fiche) {
    final source = fiche.source.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Informations',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Date de collecte',
              DateFormat('dd/MM/yyyy à HH:mm').format(fiche.dateCollecte)),
          if (fiche.scoreInteret != null)
            _buildInfoRow('Score d\'intérêt', '${fiche.scoreInteret}/10',
                color: _getScoreColor(fiche.scoreInteret!)),
          if (source != null) _buildInfoRow('Source', source.libelleSource),
          if (fiche.commentaire != null && fiche.commentaire!.isNotEmpty)
            _buildInfoRow('Commentaire', fiche.commentaire!),
          const Divider(height: 24),
          _buildInfoRow('Nombre de prospects', '${prospectsDetails.length}',
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProspectsList(List<ProspectDetails> prospectsDetails) {
    if (prospectsDetails.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.lightShadow,
        ),
        child: const Center(
          child: Text(
            'Aucun prospect dans cette fiche',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.people_outline,
                  color: AppColors.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Liste des prospects',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prospectsDetails.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) =>
                _buildProspectTile(prospectsDetails[index], index + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildProspectTile(ProspectDetails details, int number) {
    final prospect = details.prosp;
    final interetsText = details.specialities.isEmpty
        ? 'Aucun intérêt'
        : details.specialities.map((s) => s.libelleSpecialite).join(', ');

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
        child: Text(
          number.toString(),
          style: const TextStyle(
              color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        prospect.nomComplet,
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(prospect.telephone, style: const TextStyle(fontSize: 12)),
          Text(
            'Établissement: ${details.etablissement}',
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
          Text(
            'Intérêts: $interetsText',
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textTertiary, size: 20),
      onTap: () => Navigator.push(
        _globalContext,
        MaterialPageRoute(
          builder: (_) => ProspectDetailScreen(prospect: details),
        ),
      ),
      // onTap: () => Navigator.pushNamed(_globalContext, AppRoutes.prospectDetails),
    );
  }

  Widget _buildNotFound() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Fiche non trouvée',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }
}
