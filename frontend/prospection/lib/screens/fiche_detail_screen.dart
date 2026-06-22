// lib/screens/fiche_detail_screen.dart

// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isetagcom/models/fiche.dart';
import 'package:isetagcom/models/localStorage/local_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../models/prospectData.dart';
import '../routes/app_router.dart';
import '../services/fiche_excel_export_service.dart';
import '../services/fiche_pdf_export_service.dart';
import '../services/translation_service.dart';
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
            print('Erreur: ${snapshot.error}');
            return Center(child: Text('error_occurred'.tr));
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildFicheInfo(fiche),
                    const SizedBox(height: 12),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(_globalContext),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'fiche_detail'.tr,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(fiche.dateCollecte),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
              onSelected: (value) async {
                if (value == 'preview_pdf') {
                  Navigator.pushNamed(context, AppRoutes.preview_fiche, arguments: {
                    'fiche': fiche,
                    'prospectsList': prospectsDetails,
                  });
                } else if (value == 'export_pdf') {
                  await _exportAndSharePDF(fiche, prospectsDetails);
                } else if (value == 'export_excel') {
                  await _exportAndShareExcel(fiche, prospectsDetails);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'preview_pdf',
                  child: Row(
                    children: [
                      const Icon(Icons.remove_red_eye, color: Colors.blue, size: 18),
                      const SizedBox(width: 10),
                      Text('preview_pdf'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'export_pdf',
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
                      const SizedBox(width: 10),
                      Text('export_pdf'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'export_excel',
                  child: Row(
                    children: [
                      const Icon(Icons.table_chart,
                          color: AppColors.primaryGreen, size: 18),
                      const SizedBox(width: 10),
                      Text('export_excel'.tr),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAndSharePDF(Fiche f, List<ProspectDetails> prosps) async {
    try {
      _showLoadingDialog('Génération du PDF...');
      
      final pdfBytes = await FichePdfExportService.generateFichePdf(f, prosps);
      
      if (mounted) Navigator.pop(context);
      
      if (pdfBytes.isNotEmpty && mounted) {
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${directory.path}/${f.idFiche}_$timestamp.pdf');
        await file.writeAsBytes(pdfBytes);
        
        _showSnackBar('PDF exporté avec succès !', Colors.green);
        
        final openResult = await OpenFile.open(file.path);
        
        if (openResult.type != ResultType.done) {
          _showSnackBar('Impossible d\'ouvrir le fichier', Colors.green);
        }
      } else {
        _showSnackBar('Erreur lors de l\'export PDF', Colors.red);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar('Erreur: $e', Colors.red);
    }
  }

  Future<void> _exportAndShareExcel(Fiche f, List<ProspectDetails> prosps) async {
    try {
      _showLoadingDialog('Génération du fichier Excel...');
      
      final excelBytes = FicheExcelExportService.exportFicheToExcel(f, prosps);
      
      if (mounted) Navigator.pop(context);
      
      if (excelBytes != null && excelBytes.isNotEmpty && mounted) {
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${directory.path}/${f.idFiche}_$timestamp.xlsx');
        await file.writeAsBytes(excelBytes);
        
        _showSnackBar('Excel exporté avec succès !', Colors.green);
        
        final openResult = await OpenFile.open(file.path);
        
        if (openResult.type != ResultType.done) {
          _showSnackBar('Impossible d\'ouvrir le fichier', Colors.green);
        }
      } else {
        _showSnackBar('Erreur lors de l\'export Excel', Colors.red);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar('Erreur lors de l\'export Excel', Colors.red);
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildFicheInfo(Fiche fiche) {
    final source = fiche.source.value;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 16),
              const SizedBox(width: 6),
              Text(
                'information'.tr,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoRow('collection_date'.tr,
              DateFormat('dd/MM/yyyy à HH:mm').format(fiche.dateCollecte)),
          if (fiche.scoreInteret != null)
            _buildInfoRow('interest_score'.tr, '${fiche.scoreInteret}/10',
                color: _getScoreColor(fiche.scoreInteret!)),
          if (source != null) _buildInfoRow('source'.tr, source.libelleSource),
          if (fiche.commentaire != null && fiche.commentaire!.isNotEmpty)
            _buildInfoRow('comment'.tr, fiche.commentaire!),
          const Divider(height: 16),
          _buildInfoRow('number_of_prospects'.tr, '${prospectsDetails.length}',
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.lightShadow,
        ),
        child: Center(
          child: Text(
            'no_prospects_in_fiche'.tr,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline,
                  color: AppColors.primaryGreen, size: 16),
              const SizedBox(width: 6),
              Text(
                'prospects_list'.tr,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
              const Spacer(),
              Text(
                '${prospectsDetails.length}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prospectsDetails.length,
            separatorBuilder: (context, index) => const Divider(height: 8),
            itemBuilder: (context, index) =>
                _buildProspectTile(prospectsDetails[index], index + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildProspectTile(ProspectDetails details, int number) {
    final prospect = details.prosp;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
        child: Text(
          number.toString(),
          style: const TextStyle(
              color: AppColors.primaryGreen, 
              fontWeight: FontWeight.bold,
              fontSize: 11),
        ),
      ),
      title: Text(
        prospect.nomComplet,
        style: const TextStyle(
            fontWeight: FontWeight.w600, 
            color: AppColors.textPrimary,
            fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prospect.telephone, 
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)
          ),
          Text(
            details.etablissement,
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textTertiary, size: 18),
      onTap: () => Navigator.push(
        _globalContext,
        MaterialPageRoute(
          builder: (_) => ProspectDetailScreen(prospect: details),
        ),
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_off_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'fiche_not_found'.tr,
            style: const TextStyle(
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