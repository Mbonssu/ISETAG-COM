import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';

import '../models/fiche.dart';
import '../models/prospectData.dart';

// Assuming imports for your local models:
// import '../models/fiche.dart';
// import '../models/prospect_details.dart';

class FichePdfExportService {
  
  /// ─── METHOD 1: GENERATE RAW PDF BYTES ───
  static Future<Uint8List> generateFichePdf(Fiche fiche, List<ProspectDetails> prospectsList) async {
    final pdf = pw.Document();
    final df = DateFormat('dd/MM/yyyy HH:mm');

    // Theme colors mapping from your AppColors palette
    const primaryGreen = PdfColor.fromInt(0xFF2E7D32);
    const secondaryGreen = PdfColor.fromInt(0xFF1B5E20);
    const textPrimary = PdfColor.fromInt(0xFF1A1A1A);
    const textSecondary = PdfColor.fromInt(0xFF5A5A5A);
    const softGreen = PdfColor.fromInt(0xFFE8F5E9);
    const borderMedium = PdfColor.fromInt(0xFFE0E0E0);
    const accentOrange = PdfColor.fromInt(0xFFF57F17);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // ─── MASTER HEADER BANNER WITH LOGO PLACEHOLDER ───
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              gradient: const pw.LinearGradient(
                colors: [primaryGreen, secondaryGreen],
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
              ),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // SCHOOL LOGO PLACEHOLDER BOX
                pw.Container(
                  width: 55,
                  height: 55,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'LOGO',
                    style: pw.TextStyle(color: primaryGreen, fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(width: 14),
                
                // HEADER TITLES & METADATA
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'ISETAG - REPORTING DE PROSPECTION',
                        style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Fiche ID: ${fiche.idFiche.toUpperCase()}',
                        style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                
                // MAIN INTEREST SCORE BADGE
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: pw.BoxDecoration(
                    color: const PdfColor.fromInt(0xFFF9A825), // starYellow
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'Score: ${fiche.scoreInteret ?? 0}/10',
                    style: pw.TextStyle(color: textPrimary, fontWeight: pw.FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),

          // ─── EXTRACT SUB-METRICS ROW ───
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Date de collecte: ${df.format(fiche.dateCollecte)}', style: const pw.TextStyle(color: textSecondary, fontSize: 10)),
              pw.Text('Total de prospects: ${prospectsList.length}', style: pw.TextStyle(color: textPrimary, fontWeight: pw.FontWeight.bold, fontSize: 10)),
            ],
          ),
          if (fiche.commentaire != null && fiche.commentaire!.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            pw.Text('Commentaire global: ${fiche.commentaire}', style: pw.TextStyle(color: textSecondary, fontSize: 9, fontItalic: Font.helvetica())),
          ],
          pw.SizedBox(height: 16),

          // ─── LOOPING DETAILED PROSPECT CARDS ───
          pw.Text('DÉTAILS DES PROSPECTS ENREGISTRÉS', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: primaryGreen)),
          pw.SizedBox(height: 8),

          ...prospectsList.map((pDetails) {
            final p = pDetails.prosp;
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderMedium),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Full name and type tier banner line
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(p.nomComplet, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: textPrimary)),
                      pw.Text(p.typeProspect.toUpperCase(), style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: accentOrange)),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  
                  // Structural Fields Grid Matrix 1
                  pw.Row(
                    children: [
                      pw.Expanded(child: _metaTxt('Tél: ', p.telephone)),
                      pw.Expanded(child: _metaTxt('Email: ', p.email ?? '-')),
                      pw.Expanded(child: _metaTxt('Sexe: ', p.sexe)),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  
                  // Structural Fields Grid Matrix 2
                  pw.Row(
                    children: [
                      pw.Expanded(child: _metaTxt('Établissement: ', pDetails.etablissement)),
                      pw.Expanded(child: _metaTxt('Classe: ', pDetails.classe)),
                      pw.Expanded(child: _metaTxt('Niv. Étude: ', p.niveauEtude)),
                    ],
                  ),
                  
                  // Optional Meta Lines
                  if (p.adresse != null && p.adresse!.isNotEmpty) ...[
                    pw.SizedBox(height: 4),
                    _metaTxt('Adresse: ', p.adresse!),
                  ],
                  if (p.date_relance != null) ...[
                    pw.SizedBox(height: 4),
                    _metaTxt('Date Relance définie: ', DateFormat('dd/MM/yyyy').format(p.date_relance!)),
                  ],
                  if (p.commentaireGen != null && p.commentaireGen!.isNotEmpty) ...[
                    pw.SizedBox(height: 4),
                    _metaTxt('Observations: ', p.commentaireGen!),
                  ],

                  // Nested Course Options Table Array (Specialities)
                  if (pDetails.specialities.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Container(
                      color: softGreen,
                      padding: const pw.EdgeInsets.all(4),
                      width: double.infinity,
                      child: pw.Text('Spécialités demandées (Par ordre de préférence) :', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: secondaryGreen)),
                    ),
                    pw.TableHelper.fromTextArray(
                      border: const pw.TableBorder(horizontalInside: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
                      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: textPrimary),
                      cellStyle: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
                      headers: ['Pref.', 'Libellé Spécialité', 'Niveau Requis', 'Commentaire / Notes'],
                      data: pDetails.specialities.map((spec) => [
                        '#${spec.orderPreference}',
                        spec.libelleSpecialite,
                        'Niveau ${spec.niveau}/10',
                        spec.commentaire ?? '',
                      ]).toList(),
                      cellPadding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
    return pdf.save();
  }

  /// Helper to map bold descriptors inside flat inline rows
  static pw.Widget _metaTxt(String label, String val) {
    return pw.RichText(
      text: pw.TextSpan(
        style: const pw.TextStyle(fontSize: 8.5),
        children: [
          pw.TextSpan(text: label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF1A1A1A))),
          pw.TextSpan(text: val, style: const pw.TextStyle(color: PdfColor.fromInt(0xFF5A5A5A))),
        ],
      ),
    );
  }
}
