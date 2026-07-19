// import 'dart:typed_data';
// import 'package:isetagcom/services/translation_service.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart' show rootBundle;

// import '../models/fiche.dart';
// import '../models/prospectData.dart';

// class FichePdfExportService {
//   /// ─── METHOD 1: GENERATE RAW PDF BYTES ───
//   static Future<Uint8List> generateFichePdf(
//     Fiche fiche,
//     List<ProspectDetails> prospectsList, {
//     Uint8List? logoBytes,
//   }) async {
//     final pdf = pw.Document();
//     final df = DateFormat('dd/MM/yyyy HH:mm');

//     // Premium Palette Settings
//     const primaryGreen = PdfColor.fromInt(0xFF2E7D32);
//     const secondaryGreen = PdfColor.fromInt(0xFF1B5E20);
//     const textPrimary = PdfColor.fromInt(0xFF1A1A1A);
//     const textSecondary = PdfColor.fromInt(0xFF5A5A5A);
//     const softGreen = PdfColor.fromInt(0xFFE8F5E9);
//     const softGreenBackground = PdfColor.fromInt(0xFFF1F8F2);
//     const borderLight = PdfColor.fromInt(0xFFECEFF1);
//     const borderMedium = PdfColor.fromInt(0xFFCFD8DC);
//     const accentOrange = PdfColor.fromInt(0xFFE65100);

//     // Dynamic Safe Asset Fallback Loader
//     Uint8List? finalLogoBytes = logoBytes;
//     if (finalLogoBytes == null) {
//       try {
//         final ByteData data =
//             await rootBundle.load('assets/images/app_icon.png');
//         finalLogoBytes = data.buffer.asUint8List();
//       } catch (e) {
//         print('⚠️ Logo asset fell back safely to text styling: $e');
//       }
//     }

//     pdf.addPage(
//       pw.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           margin: const pw.EdgeInsets.all(28),
//           build: (context) => [
//                 // ─── HERO BANNER HEADBLOCK ───
//                 pw.Container(
//                   padding: const pw.EdgeInsets.symmetric(
//                       horizontal: 18, vertical: 16),
//                   decoration: pw.BoxDecoration(
//                     gradient: const pw.LinearGradient(
//                       colors: [primaryGreen, secondaryGreen],
//                       begin: pw.Alignment.topLeft,
//                       end: pw.Alignment.bottomRight,
//                     ),
//                     borderRadius: pw.BorderRadius.circular(8),
//                   ),
//                   child: pw.Row(
//                     crossAxisAlignment: pw.CrossAxisAlignment.center,
//                     children: [
//                       pw.Container(
//                         width: 54,
//                         height: 54,
//                         decoration: pw.BoxDecoration(
//                           color: PdfColors.white,
//                           borderRadius: pw.BorderRadius.circular(8),
//                         ),
//                         alignment: pw.Alignment.center,
//                         child: finalLogoBytes != null
//                             ? pw.Padding(
//                                 padding: const pw.EdgeInsets.all(4),
//                                 child: pw.Image(pw.MemoryImage(finalLogoBytes),
//                                     fit: pw.BoxFit.contain),
//                               )
//                             : pw.Text(
//                                 'ISETAG',
//                                 style: pw.TextStyle(
//                                     color: primaryGreen,
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                       ),
//                       pw.SizedBox(width: 16),
//                       pw.Expanded(
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text(
//                               'report_fiche'.tr.toUpperCase(),
//                               style: pw.TextStyle(
//                                   color: PdfColors.white,
//                                   fontWeight: pw.FontWeight.bold,
//                                   fontSize: 13,
//                                   letterSpacing: 0.5),
//                             ),
//                             pw.SizedBox(height: 4),
//                             pw.Text(
//                               '${'fiche_id'.tr}: ${fiche.idFiche.toUpperCase()}',
//                               style: pw.TextStyle(
//                                   color: PdfColors.white,
//                                   fontSize: 9,
//                                   fontBold: pw.Font.helveticaBold()),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // pw.Container(
//                       //   padding: const pw.EdgeInsets.symmetric(
//                       //       horizontal: 12, vertical: 6),
//                       //   decoration: pw.BoxDecoration(
//                       //     color: const PdfColor.fromInt(0xFFFFC107),
//                       //     borderRadius: pw.BorderRadius.circular(20),
//                       //   ),
//                       //   child: pw.Text(
//                       //     '${'score'.tr}: ${fiche.scoreInteret ?? 0}/10',
//                       //     style: pw.TextStyle(
//                       //         color: textPrimary,
//                       //         fontWeight: pw.FontWeight.bold,
//                       //         fontSize: 11),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//                 pw.SizedBox(height: 16),

//                 // ─── GENERAL METADATA ROW ───
//                 pw.Container(
//                   padding: const pw.EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 8),
//                   decoration: const pw.BoxDecoration(
//                     border: pw.Border(
//                         bottom:
//                             pw.BorderSide(color: borderMedium, width: 0.75)),
//                   ),
//                   child: pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text(
//                           '${'collection_date'.tr}: ${df.format(fiche.dateCollecte)}',
//                           style: const pw.TextStyle(
//                               color: textSecondary, fontSize: 9)),
//                       pw.Text(
//                           '${'total_prospects'.tr}: ${prospectsList.length}',
//                           style: pw.TextStyle(
//                               color: primaryGreen,
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 10)),
//                     ],
//                   ),
//                 ),

//                 if (fiche.commentaire != null &&
//                     fiche.commentaire!.isNotEmpty) ...[
//                   pw.Container(
//                     width: double.infinity,
//                     margin: const pw.EdgeInsets.only(top: 8),
//                     padding: const pw.EdgeInsets.all(8),
//                     decoration: pw.BoxDecoration(
//                         color: softGreenBackground,
//                         borderRadius: pw.BorderRadius.circular(4)),
//                     child: pw.Text(
//                         '${'global_comment'.tr}: ${fiche.commentaire}',
//                         style: pw.TextStyle(
//                             color: textSecondary,
//                             fontSize: 9,
//                             fontItalic: pw.Font.helveticaOblique())),
//                   ),
//                 ],
//                 pw.SizedBox(height: 18),

//                 // ─── PROSPECTS LIST CARDS SECTION ───
//                 pw.Text('prospects_details'.tr.toUpperCase(),
//                     style: pw.TextStyle(
//                         fontSize: 10,
//                         fontWeight: pw.FontWeight.bold,
//                         color: textSecondary,
//                         letterSpacing: 0.5)),
//                 pw.SizedBox(height: 10),

//                 ...prospectsList.map((pDetails) {
//                   final p = pDetails.prosp;
//                   return pw.Container(
//                       margin: const pw.EdgeInsets.only(bottom: 16),
//                       decoration: pw.BoxDecoration(
//                         color: PdfColors.white,
//                         border: pw.Border.all(color: borderLight, width: 1),
//                         borderRadius: pw.BorderRadius.circular(8),
//                       ),
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Container(
//                             padding: const pw.EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                             decoration: const pw.BoxDecoration(
//                               color: softGreen,
//                               borderRadius: pw.BorderRadius.only(
//                                   topLeft: pw.Radius.circular(8),
//                                   topRight: pw.Radius.circular(8)),
//                             ),
//                             child: pw.Row(
//                               mainAxisAlignment:
//                                   pw.MainAxisAlignment.spaceBetween,
//                               children: [
//                                 pw.Text(p.nomComplet,
//                                     style: pw.TextStyle(
//                                         fontSize: 11,
//                                         fontWeight: pw.FontWeight.bold,
//                                         color: textPrimary)),
//                                 pw.Container(
//                                   padding: const pw.EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 3),
//                                   decoration: pw.BoxDecoration(
//                                       color: PdfColors.white,
//                                       borderRadius: pw.BorderRadius.circular(4),
//                                       border:
//                                           pw.Border.all(color: borderMedium)),
//                                   child: pw.Text(p.typeProspect.toUpperCase(),
//                                       style: pw.TextStyle(
//                                           fontSize: 8,
//                                           fontWeight: pw.FontWeight.bold,
//                                           color: accentOrange)),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(12),
//                             child: pw.Column(
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Row(
//                                   children: [
//                                     pw.Expanded(
//                                         child: _metaTxt(
//                                             '${'phone'.tr}: ', p.telephone)),
//                                     pw.Expanded(
//                                         child: _metaTxt('${'email'.tr}: ',
//                                             p.email ?? 'no_email'.tr)),
//                                     pw.Expanded(
//                                         child: _metaTxt(
//                                             '${'gender'.tr}: ', p.sexe)),
//                                   ],
//                                 ),
//                                 pw.SizedBox(height: 6),

//                                 pw.Row(
//                                   children: [
//                                     pw.Expanded(
//                                         child: _metaTxt(
//                                             '${'establishment'.tr}: ',
//                                             pDetails.etablissement.nomEtablissement)),
//                                     pw.Expanded(
//                                         child: _metaTxt('${'class'.tr}: ',
//                                             pDetails.classe.libelleClasse)),
//                                     pw.Expanded(
//                                         child: _metaTxt(
//                                             '${'education_level'.tr}: ',
//                                             p.niveauEtude)),
//                                   ],
//                                 ),
//                                 pw.SizedBox(height: 6),

//                                 pw.Row(
//                                   children: [
//                                     pw.Expanded(
//                                         child: _metaTxt('${'source'.tr}: ',
//                                             p.source_infos ?? '-')),
//                                     pw.Expanded(
//                                       child: (p.date_relance != null)
//                                           ? _metaTxt(
//                                               '${'followup_date'.tr}: ',
//                                               DateFormat('dd/MM/yyyy')
//                                                   .format(p.date_relance!))
//                                           : pw.SizedBox(),
//                                     ),
//                                     pw.Expanded(
//                                       child: (p.adresse != null &&
//                                               p.adresse!.isNotEmpty)
//                                           ? _metaTxt(
//                                               '${'address'.tr}: ', p.adresse!)
//                                           : pw.SizedBox(),
//                                     ),
//                                   ],
//                                 ),

//                                 if (p.commentaireGen != null &&
//                                     p.commentaireGen!.isNotEmpty) ...[
//                                   pw.SizedBox(height: 8),
//                                   pw.Container(
//                                     padding: const pw.EdgeInsets.all(6),
//                                     width: double.infinity,
//                                     decoration: pw.BoxDecoration(
//                                         color: PdfColors.grey50,
//                                         borderRadius:
//                                             pw.BorderRadius.circular(4)),
//                                     child: _metaTxt('${'observations'.tr}: ',
//                                         p.commentaireGen!),
//                                   ),
//                                 ],

//                                 // Nested Preference Choices Table Frame
//                                 if (pDetails.specialities.isNotEmpty) ...[
//                                   pw.SizedBox(height: 12),
//                                   pw.Container(
//                                     padding: const pw.EdgeInsets.symmetric(
//                                         horizontal: 6, vertical: 4),
//                                     width: double.infinity,
//                                     decoration: const pw.BoxDecoration(
//                                       color: secondaryGreen,
//                                       borderRadius: pw.BorderRadius.only(
//                                           topLeft: pw.Radius.circular(4),
//                                           topRight: pw.Radius.circular(4)),
//                                     ),
//                                     child: pw.Text(
//                                       'specialities_requested'.tr.toUpperCase(),
//                                       style: pw.TextStyle(
//                                           fontSize: 7.5,
//                                           fontWeight: pw.FontWeight.bold,
//                                           color: PdfColors.white,
//                                           letterSpacing: 0.3),
//                                     ),
//                                   ),
//                                   pw.TableHelper.fromTextArray(
//                                     border: pw.TableBorder.all(
//                                         color: borderLight, width: 0.5),
//                                     headerStyle: pw.TextStyle(
//                                         fontSize: 8,
//                                         fontWeight: pw.FontWeight.bold,
//                                         color: textPrimary),
//                                     cellStyle: const pw.TextStyle(
//                                         fontSize: 7.5, color: textPrimary),
//                                     headerDecoration: const pw.BoxDecoration(
//                                         color: PdfColors.grey200),

//                                     // FIXED: Directly providing a decoration styling builder mapping alternating lines context safely
//                                     rowDecoration: const pw.BoxDecoration(
//                                         color: PdfColors.white),
//                                     cellDecoration: (int columnIndex,
//                                         dynamic data, int rowIndex) {
//                                       return pw.BoxDecoration(
//                                         color: rowIndex % 2 == 0
//                                             ? PdfColors.grey50
//                                             : PdfColors.white,
//                                       );
//                                     },

//                                     headers: [
//                                       'preference'.tr,
//                                       'speciality_name'.tr,
//                                       'required_level'.tr,
//                                       'comments_notes'.tr
//                                     ],
//                                     data: pDetails.specialities
//                                         .map((spec) => [
//                                               '#${spec.orderPreference}',
//                                               spec.libelleSpecialite,
//                                               '${'level'.tr} ${spec.niveau}/10',
//                                               spec.commentaire ?? '',
//                                             ])
//                                         .toList(),
//                                     cellPadding: const pw.EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 6),
//                                     cellAlignment: pw.Alignment.centerLeft,
//                                     cellAlignments: {0: pw.Alignment.center},
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         ],
//                       ));
//                 })
//               ]),
//     );
//     return pdf.save();
//   }

//   static pw.Widget _metaTxt(String label, String val) {
//     return pw.RichText(
//       text: pw.TextSpan(
//         style: const pw.TextStyle(
//             fontSize: 8, color: PdfColor.fromInt(0xFF5A5A5A)),
//         children: [
//           pw.TextSpan(
//             text: label,
//             style: pw.TextStyle(
//                 fontWeight: pw.FontWeight.bold,
//                 color: const PdfColor.fromInt(0xFF263238)),
//           ),
//           pw.TextSpan(text: val),
//         ],
//       ),
//     );
//   }
// }






import 'dart:typed_data';
import 'package:isetagcom/services/translation_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/fiche.dart';
import '../models/prospectData.dart';

class FichePdfExportService {
  /// ─── METHOD 1: GENERATE RAW PDF BYTES ───
  static Future<Uint8List> generateFichePdf(
    Fiche fiche,
    List<ProspectDetails> prospectsList, {
    Uint8List? logoBytes,
  }) async {
    final pdf = pw.Document();
    final df = DateFormat('dd/MM/yyyy HH:mm');

    // Premium Palette Settings
    const primaryGreen = PdfColor.fromInt(0xFF2E7D32);
    const secondaryGreen = PdfColor.fromInt(0xFF1B5E20);
    const textPrimary = PdfColor.fromInt(0xFF1A1A1A);
    const textSecondary = PdfColor.fromInt(0xFF5A5A5A);
    const softGreenBackground = PdfColor.fromInt(0xFFF1F8F2);
    const borderLight = PdfColor.fromInt(0xFFECEFF1);
    const borderMedium = PdfColor.fromInt(0xFFCFD8DC);
    
    // Custom Table Designs
    const tableHeaderGreen = PdfColor.fromInt(0xFF1B5E20);
    const tableHeaderYellowText = PdfColor.fromInt(0xFFFBC02D); // Nice vibrant yellow for header texts
    const oddRowTransparentGreen = PdfColor.fromInt(0xFFE8F5E9); // Light transparent-feeling green

    // Dynamic Safe Asset Fallback Loader
    Uint8List? finalLogoBytes = logoBytes;
    if (finalLogoBytes == null) {
      try {
        final ByteData data =
            await rootBundle.load('assets/images/app_icon.png');
        finalLogoBytes = data.buffer.asUint8List();
      } catch (e) {
        print(' Logo asset fell back safely to text styling: $e');
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape, // Switched to landscape to safely look great in multi-column rows
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // ─── HERO BANNER HEADBLOCK ───
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                pw.Container(
                  width: 54,
                  height: 54,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  alignment: pw.Alignment.center,
                  child: finalLogoBytes != null
                      ? pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Image(pw.MemoryImage(finalLogoBytes),
                              fit: pw.BoxFit.contain),
                        )
                      : pw.Text(
                          'ISETAG',
                          style: pw.TextStyle(
                              color: primaryGreen,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold),
                        ),
                ),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'report_fiche'.tr.toUpperCase(),
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.5),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${'fiche_id'.tr}: ${fiche.idFiche.toUpperCase()}',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 9,
                            fontBold: pw.Font.helveticaBold()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // ─── GENERAL METADATA ROW ───
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                  bottom: pw.BorderSide(color: borderMedium, width: 0.75)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                    '${'collection_date'.tr}: ${df.format(fiche.dateCollecte)}',
                    style: const pw.TextStyle(color: textSecondary, fontSize: 9)),
                pw.Text(
                    '${'total_prospects'.tr}: ${prospectsList.length}',
                    style: pw.TextStyle(
                        color: primaryGreen,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10)),
              ],
            ),
          ),

          if (fiche.commentaire != null && fiche.commentaire!.isNotEmpty) ...[
            pw.Container(
              width: double.infinity,
              margin: const pw.EdgeInsets.only(top: 8),
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                  color: softGreenBackground,
                  borderRadius: pw.BorderRadius.circular(4)),
              child: pw.Text(
                  '${'global_comment'.tr}: ${fiche.commentaire}',
                  style: pw.TextStyle(
                      color: textSecondary,
                      fontSize: 9,
                      fontItalic: pw.Font.helveticaOblique())),
            ),
          ],
          pw.SizedBox(height: 18),

          // ─── PROSPECTS DATA TABLE ───
          pw.Text('prospects_details'.tr.toUpperCase(),
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: textSecondary,
                  letterSpacing: 0.5)),
          pw.SizedBox(height: 10),

          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: borderLight, width: 0.5),
            headerStyle: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: tableHeaderYellowText,
            ),
            cellStyle: const pw.TextStyle(
              fontSize: 8.5,
              color: textPrimary,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: tableHeaderGreen,
            ),
            // Custom row decoration: Alternating Row Colors (Odd lines Transparent Green, Even lines White)
            rowDecoration: const pw.BoxDecoration(), 
            cellDecoration: (int columnIndex, dynamic data, int rowIndex) {
              // rowIndex 0 represents the header item inside the matrix array builder
              if (rowIndex == 0) {
                return const pw.BoxDecoration(color: tableHeaderGreen);
              }
              return pw.BoxDecoration(
                color: rowIndex % 2 != 0 
                    ? oddRowTransparentGreen 
                    : PdfColors.white,
              );
            },
            headers: [
              'name'.tr,
              'type'.tr,
              'phone'.tr,
              'email'.tr,
              'establishment'.tr,
              'class'.tr,
              'education_level'.tr,
              'specialities_requested'.tr,
            ],
            data: prospectsList.map((pDetails) {
              final p = pDetails.prosp;
              
              // Formatting specialities cleanly inside its single string space cell entry
              final specString = pDetails.specialities.isNotEmpty
                  ? pDetails.specialities
                      .map((s) => '${s.libelleSpecialite.tr} (#${s.orderPreference})')
                      .join(', ')
                  : '-';

              return [
                p.nomComplet,
                p.typeProspect.toUpperCase(),
                p.telephone,
                p.email ?? '-',
                pDetails.etablissement.nomEtablissement,
                pDetails.classe.libelleClasse.tr,
                p.niveauEtude,
                specString,
              ];
            }).toList(),
            cellPadding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );
    return pdf.save();
  }
}