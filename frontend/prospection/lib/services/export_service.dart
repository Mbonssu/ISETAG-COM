// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:isetagcom/models/fiche.dart';
// import 'package:isetagcom/models/prospects.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../models/pros.dart';

class ExportService {
  // En-têtes pour les prospects
  static const List<String> _prospectHeaders = [
    'Nom complet',
    'Téléphone',
    'Email',
    'Niveau d\'étude',
    'Sexe',
    'Type prospect',
    'Établissement',
    'Classe',
    'Spécialité',
    'Source',
    'Score intérêt',
    'Concerne',
    'Adresse',
    'Date création'
  ];

  // Helper pour ajouter une ligne dans Excel
  static void _addRow(Sheet sheet, List<dynamic> values) {
    final List<CellValue?> cells = [];
    for (var value in values) {
      if (value == null || value == '') {
        cells.add(TextCellValue(''));
      } else if (value is String) {
        cells.add(TextCellValue(value));
      } else if (value is int) {
        cells.add(IntCellValue(value));
      } else if (value is double) {
        cells.add(DoubleCellValue(value));
      } else if (value is DateTime) {
        cells.add(TextCellValue(DateFormat('dd/MM/yyyy HH:mm').format(value)));
      } else {
        cells.add(TextCellValue(value.toString()));
      }
    }
    sheet.appendRow(cells);
  }

  // ==================== APERÇUS ====================
  
  /// Aperçu PDF d'une fiche (ouvre la fenêtre d'impression)
  static Future<void> previewFichePDF(Fiche fiche) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) => [
            // En-tête
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'FICHE DE PROSPECTION',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                ],
              ),
            ),
            
            // Informations de la fiche
            _buildInfoSection('Informations générales', [
              _buildInfoRow('ID Fiche', fiche.idFiche),
              _buildInfoRow('Date de création', DateFormat('dd/MM/yyyy HH:mm').format(fiche.createdAt)),
              _buildInfoRow('Date de collecte', DateFormat('dd/MM/yyyy HH:mm').format(fiche.dateCollecte)),
              _buildInfoRow('Score d\'intérêt', '${fiche.scoreInteret}/10'),
              // _buildInfoRow('Source', fiche.src.libelleSource),
              _buildInfoRow('Commentaire', fiche.commentaire ?? 'Aucun'),
            ]),
            
            pw.SizedBox(height: 20),
            
            // Liste des prospects
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Liste des prospects (${fiche.prospects.length})',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  if (fiche.prospects.isEmpty)
                    pw.Text('Aucun prospect dans cette fiche')
                  else
                    pw.Table.fromTextArray(
                      headers: ['N°', 'Nom', 'Téléphone', 'Email', 'Type', 'Niveau'],
                      data: fiche.prospects.toList().asMap().entries.map((entry) {
                        final prospect = entry.value;
                        return [
                          (entry.key + 1).toString(),
                          prospect.nomComplet,
                          prospect.telephone,
                          prospect.email ?? '',
                          prospect.typeProspect,
                          prospect.niveauEtude,
                        ];
                      }).toList(),
                      headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                      headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
                      cellStyle: const pw.TextStyle(fontSize: 9),
                      cellAlignment: pw.Alignment.centerLeft,
                    ),
                ],
              ),
            ),
            
            // Statistiques
            _buildInfoSection('Statistiques', [
              _buildInfoRow('Total prospects', fiche.prospects.length.toString()),
              _buildInfoRow('Répartition par type', _getTypeDistribution(fiche.prospects as List<Prospect>)),
              _buildInfoRow('Répartition par sexe', _getSexeDistribution(fiche.prospects as List<Prospect>)),
            ]),
            
            _buildFooter(),
          ],
        ),
      );
      
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('Erreur aperçu PDF: $e');
    }
  }

  /// Aperçu Excel d'une fiche (ouvre le fichier dans l'application par défaut)
  static Future<void> previewFicheExcel(Fiche fiche) async {
    try {
      final file = await exportFicheToExcel(fiche);
      if (file != null) {
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')],
          text: 'Aperçu de la fiche de prospection',
        );
      }
    } catch (e) {
      print('Erreur aperçu Excel: $e');
    }
  }

  // ==================== EXPORT FICHE VERS EXCEL ====================
  
  /// Exporter une fiche unique vers Excel
  static Future<File?> exportFicheToExcel(Fiche fiche) async {
    try {
      var excel = Excel.createExcel();
      
      // === Feuille 1: Informations de la fiche ===
      Sheet infoSheet = excel['Fiche_Information'];
      _addRow(infoSheet, ['FICHE DE PROSPECTION', '']);
      _addRow(infoSheet, ['']);
      _addRow(infoSheet, ['ID Fiche', fiche.idFiche]);
      _addRow(infoSheet, ['Date de création', fiche.createdAt]);
      _addRow(infoSheet, ['Date de collecte', fiche.dateCollecte]);
      _addRow(infoSheet, ['Score d\'intérêt', '${fiche.scoreInteret}/10']);
      _addRow(infoSheet, ['Source', fiche.source.value?.libelleSource ?? 'Inconnue']);
      _addRow(infoSheet, ['Commentaire', fiche.commentaire ?? 'Aucun']);
      _addRow(infoSheet, ['']);
      _addRow(infoSheet, ['Nombre de prospects', fiche.prospects.length]);
      
      // === Feuille 2: Liste des prospects ===
      Sheet prospectsSheet = excel['Liste_des_Prospects'];
      _addRow(prospectsSheet, _prospectHeaders);
      
      for (var prospect in fiche.prospects) {
        _addRow(prospectsSheet, [
          prospect.nomComplet,
          prospect.telephone,
          prospect.email ?? '',
          prospect.niveauEtude ?? '',
          prospect.sexe ?? '',
          prospect.typeProspect ?? '',
          // prospect.etablissement?.nomEtablissement ?? '',
          // prospect.classe?.libelleClasse ?? '',
          // prospect.specialite?.libelleSpecialite ?? '',
          // prospect.source?.libelleSource ?? '',
          fiche.scoreInteret,
          prospect.concerne ?? '',
          prospect.adresse ?? '',
          prospect.createdAt,
        ]);
      }
      
      // === Feuille 3: Statistiques ===
      Sheet statsSheet = excel['Statistiques'];
      _addRow(statsSheet, ['RÉSUMÉ STATISTIQUE', '']);
      _addRow(statsSheet, ['Total prospects', fiche.prospects.length]);
      
      // Statistiques par type
      Map<String, int> typeStats = {};
      for (var p in fiche.prospects) {
        String type = p.typeProspect ?? 'Non spécifié';
        typeStats[type] = (typeStats[type] ?? 0) + 1;
      }
      _addRow(statsSheet, ['']);
      _addRow(statsSheet, ['Répartition par type:', '']);
      for (var entry in typeStats.entries) {
        _addRow(statsSheet, ['  ${entry.key}', entry.value]);
      }
      
      // Statistiques par sexe
      Map<String, int> sexeStats = {};
      for (var p in fiche.prospects) {
        String sexe = p.sexe ?? 'Non spécifié';
        sexeStats[sexe] = (sexeStats[sexe] ?? 0) + 1;
      }
      _addRow(statsSheet, ['']);
      _addRow(statsSheet, ['Répartition par sexe:', '']);
      for (var entry in sexeStats.entries) {
        _addRow(statsSheet, ['  ${entry.key}', entry.value]);
      }
      
      return await _saveExcel(excel, 'fiche_${fiche.idFiche}');
    } catch (e) {
      print('Erreur export Fiche Excel: $e');
      return null;
    }
  }

  // ==================== EXPORT FICHE VERS PDF ====================
  
  /// Exporter une fiche unique vers PDF
  static Future<File?> exportFicheToPDF(Fiche fiche) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) => [
            // En-tête
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'FICHE DE PROSPECTION',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                ],
              ),
            ),
            
            // Informations de la fiche
            _buildInfoSection('Informations générales', [
              _buildInfoRow('ID Fiche', fiche.idFiche),
              _buildInfoRow('Date de création', DateFormat('dd/MM/yyyy HH:mm').format(fiche.createdAt)),
              _buildInfoRow('Date de collecte', DateFormat('dd/MM/yyyy HH:mm').format(fiche.dateCollecte)),
              _buildInfoRow('Score d\'intérêt', '${fiche.scoreInteret}/10'),
              // _buildInfoRow('Source', fiche.src.libelleSource),
              _buildInfoRow('Source', fiche.source.value?.libelleSource ?? 'Inconnue'),
              _buildInfoRow('Commentaire', fiche.commentaire ?? 'Aucun'),
            ]),
            
            pw.SizedBox(height: 20),
            
            // Liste des prospects
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Liste des prospects (${fiche.prospects.length})',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  if (fiche.prospects.isEmpty)
                    pw.Text('Aucun prospect dans cette fiche')
                  else
                    // ignore: deprecated_member_use
                    pw.Table.fromTextArray(
                      headers: ['N°', 'Nom', 'Téléphone', 'Email', 'Type', 'Niveau'],
                      data: fiche.prospects.toList().asMap().entries.map((entry) {
                        final prospect = entry.value;
                        return [
                          (entry.key + 1).toString(),
                          prospect.nomComplet,
                          prospect.telephone,
                          prospect.email ?? '',
                          prospect.typeProspect,
                          prospect.niveauEtude,
                        ];
                      }).toList(),
                      headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                      headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
                      cellStyle: const pw.TextStyle(fontSize: 9),
                      cellAlignment: pw.Alignment.centerLeft,
                    ),
                ],
              ),
            ),
            
            // Statistiques
            _buildInfoSection('Statistiques', [
              _buildInfoRow('Total prospects', fiche.prospects.length.toString()),
              _buildInfoRow('Répartition par type', _getTypeDistribution(fiche.prospects as List<Prospect>)),
              _buildInfoRow('Répartition par sexe', _getSexeDistribution(fiche.prospects as List<Prospect>)),
            ]),
            
            _buildFooter(),
          ],
        ),
      );
      
      return await _savePDF(pdf, 'fiche_${fiche.idFiche}');
    } catch (e) {
      print('Erreur export Fiche PDF: $e');
      return null;
    }
  }

  // ==================== EXPORT LISTE DE FICHES ====================
  
  /// Exporter plusieurs fiches vers Excel
  static Future<File?> exportFichesToExcel(List<Fiche> fiches) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Fiches'];
      
      _addRow(sheet, ['ID Fiche', 'Date collecte', 'Score', 'Source', 'Nb Prospects', 'Date création']);
      
      for (var fiche in fiches) {
        _addRow(sheet, [
          fiche.idFiche,
          fiche.dateCollecte,
          fiche.scoreInteret,
          fiche.source.value?.libelleSource ?? 'Inconnue',
          fiche.prospects.length,
          fiche.createdAt,
        ]);
      }
      
      return await _saveExcel(excel, 'fiches');
    } catch (e) {
      print('Erreur export Liste Fiches Excel: $e');
      return null;
    }
  }

  // ==================== PARTAGE ====================

  static Future<void> shareFile(File file, String fileName) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path, mimeType: fileName.endsWith('.pdf') 
            ? 'application/pdf' 
            : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')],
        text: 'Voici la fiche de prospection ISETAG',
      );
    } catch (e) {
      print('Erreur partage: $e');
    }
  }

  // ==================== MÉTHODES PRIVÉES ====================

  static Future<File> _saveExcel(Excel excel, String baseName) async {
    final directory = await getTemporaryDirectory();
    final fileName = '${baseName}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
    final filePath = '${directory.path}/$fileName';
    final excelBytes = excel.encode();
    if (excelBytes != null) {
      await File(filePath).writeAsBytes(excelBytes);
    }
    return File(filePath);
  }

  static Future<File> _savePDF(pw.Document pdf, String baseName) async {
    final directory = await getTemporaryDirectory();
    final fileName = '${baseName}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildHeader(String title, int count, String date, {String? subtitle}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
          pw.SizedBox(height: 5),
          pw.Text('Date : $date', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
          pw.Text('Total : $count élément${count > 1 ? 's' : ''}', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
          if (subtitle != null) pw.Text(subtitle, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
          pw.Divider(),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        children: [
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('Rapport généré automatiquement par ISETAG', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500)),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoSection(String title, List<pw.Widget> rows) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...rows,
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.Container(width: 120, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Text(': '),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  static String _getTypeDistribution(List<Prospect> prospects) {
    final Map<String, int> typeCount = {};
    for (var prospect in prospects) {
      final type = prospect.typeProspect ?? 'Non spécifié';
      typeCount[type] = (typeCount[type] ?? 0) + 1;
    }
    return typeCount.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }

  static String _getSexeDistribution(List<Prospect> prospects) {
    final Map<String, int> sexeCount = {};
    for (var prospect in prospects) {
      final sexe = prospect.sexe ?? 'Non spécifié';
      sexeCount[sexe] = (sexeCount[sexe] ?? 0) + 1;
    }
    return sexeCount.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }
}

extension on Fiche {
  static Iterable<Object?>? get pros => null;
}