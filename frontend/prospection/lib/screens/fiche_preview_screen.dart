// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../models/fiche.dart';
import '../models/prospectData.dart';
import '../services/fiche_excel_export_service.dart';
import '../services/fiche_pdf_export_service.dart';
import '../services/translation_service.dart';
import '../utils/themes/app_colors.dart';

class FichePreviewScreen extends StatefulWidget {
  final Fiche fiche;
  final List<ProspectDetails> prospectsList;
  final bool showActions; 

  const FichePreviewScreen({
    super.key, 
    required this.fiche,
    required this.prospectsList,
    this.showActions = true,
  });

  @override
  State<FichePreviewScreen> createState() => _FichePreviewScreenState();
}

class _FichePreviewScreenState extends State<FichePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'fiche_preview'.tr,
        style: const TextStyle(color: AppColors.textOnPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AppColors.primaryGreen,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: widget.showActions ? [
        PopupMenuButton<String>(
          icon: const Icon(Icons.download_rounded, color: Colors.white),
          onSelected: (value) async {
            if (value == 'pdf') {
              await _exportAndOpenPDF(context);
            } else if (value == 'excel') {
              await _exportAndOpenExcel(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'pdf', 
              child: Row(children: [
                Icon(Icons.picture_as_pdf, color: Colors.red, size: 20), 
                SizedBox(width: 8), 
                Text('Exporter en PDF')
              ])
            ),
            const PopupMenuItem(
              value: 'excel', 
              child: Row(children: [
                Icon(Icons.grid_on_rounded, color: Colors.green, size: 20), 
                SizedBox(width: 8), 
                Text('Exporter en Excel')
              ])
            ),
          ],
        ),
      ] : null,
    );
  }

  Future<void> _exportAndOpenPDF(BuildContext context) async {
    try {
      _showLoadingDialog(context, 'Génération du PDF...');
      
      final pdfBytes = await FichePdfExportService.generateFichePdf(widget.fiche, widget.prospectsList);
      
      if (mounted) Navigator.pop(context);
      
      if (pdfBytes.isNotEmpty && mounted) {
        // Save bytes to temporary file
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${directory.path}/fiche_${widget.fiche.idFiche}_$timestamp.pdf');
        await file.writeAsBytes(pdfBytes);
        
        _showSnackBar(context, 'PDF exporté avec succès !');
        
        // Open the PDF file
        final openResult = await OpenFile.open(file.path);
        
        if (openResult.type != ResultType.done) {
          _showSnackBar(context, 'Impossible d\'ouvrir le fichier', isError: true);
        }
      } else {
        _showSnackBar(context, 'Erreur lors de l\'export PDF', isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar(context, 'Erreur: $e', isError: true);
    }
  }

  Future<void> _exportAndOpenExcel(BuildContext context) async {
    try {
      _showLoadingDialog(context, 'Génération du fichier Excel...');
      
      final excelBytes = FicheExcelExportService.exportFicheToExcel(widget.fiche, widget.prospectsList);
      
      if (mounted) Navigator.pop(context);
      
      if (excelBytes != null && excelBytes.isNotEmpty && mounted) {
        // Save bytes to temporary file
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${directory.path}/fiche_${widget.fiche.idFiche}_$timestamp.xlsx');
        await file.writeAsBytes(excelBytes);
        
        _showSnackBar(context, 'Excel exporté avec succès !');
        
        // Open the Excel file
        final openResult = await OpenFile.open(file.path);
        
        if (openResult.type != ResultType.done) {
          _showSnackBar(context, 'Impossible d\'ouvrir le fichier', isError: true);
        }
      } else {
        _showSnackBar(context, 'Erreur lors de l\'export Excel', isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar(context, 'Erreur: $e', isError: true);
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
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

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildBody() {
    final recordCount = widget.prospectsList.length;
    final formattedDate = DateFormat('dd/MM/yyyy').format(widget.fiche.dateCollecte);
    final recordText = 'records_count'.tr.replaceFirst('{count}', '$recordCount');
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.borderMedium),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'fiche_id_label'.tr.replaceFirst('{id}', widget.fiche.idFiche.substring(0, 8).toUpperCase()),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'collected_on'.tr.replaceFirst('{date}', formattedDate).replaceFirst('{count}', recordText),
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderMedium),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PdfPreview(
                  build: (format) async {
                    final pdfBytes = await FichePdfExportService.generateFichePdf(
                      widget.fiche, 
                      widget.prospectsList
                    );
                    return pdfBytes ?? Uint8List(0);
                  },
                  allowSharing: true,  
                  allowPrinting: true, 
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  loadingWidget: const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGreen),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}