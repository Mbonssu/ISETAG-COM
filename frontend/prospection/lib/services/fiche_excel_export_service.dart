import 'package:excel/excel.dart';

import '../models/fiche.dart';
import '../models/prospectData.dart';
import 'translation_service.dart';

class FicheExcelExportService {
  /// Updated to accept both Fiche (for top meta rows) and the standalone prospectsList
  static List<int>? exportFicheToExcel(
      Fiche fiche, List<ProspectDetails> prospectsList) {
    final Excel excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, 'Fiche Prospection');
    final Sheet sheet = excel['Fiche Prospection'];

    // Styles Setup using ExcelColor formatting
    final CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#2E7D32'), // primaryGreen
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'), // textOnPrimary
      fontFamily: getFontFamily(FontFamily.Arial),
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // ✅ FIXED: Using textWrapping: TextWrapping.WrapText
    final CellStyle zebraStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'), // backgroundGrey
      fontColorHex: ExcelColor.fromHexString('#1A1A1A'), // textPrimary
      fontFamily: getFontFamily(FontFamily.Arial),
      verticalAlign: VerticalAlign.Top, // Top-align text for rows that stretch vertically
      textWrapping: TextWrapping.WrapText, // ✅ Tells Excel to break lines on \n
    );

    final CellStyle normalStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#FFFFFF'), // backgroundWhite
      fontColorHex: ExcelColor.fromHexString('#1A1A1A'), // textPrimary
      fontFamily: getFontFamily(FontFamily.Arial),
      verticalAlign: VerticalAlign.Top, // Top-align text for rows that stretch vertically
      textWrapping: TextWrapping.WrapText, // ✅ Tells Excel to break lines on \n
    );

    // Write Master Fiche Info Rows at top
    sheet.appendRow([
      TextCellValue('ID FICHE:'),
      TextCellValue(fiche.idFiche),
      TextCellValue('Date Collecte:'),
      TextCellValue(fiche.dateCollecte.toIso8601String().split('T')[0])
    ]);

    sheet.appendRow([
      TextCellValue('Score Intérêt:'),
      TextCellValue('${fiche.scoreInteret ?? 0}/10'),
      TextCellValue('Notes Globale:'),
      TextCellValue(fiche.commentaire ?? '')
    ]);

    // Empty separator row
    sheet.appendRow([]);

    // Main Table Headers
    final List<String> headers = [
      'Nom Prospect',
      'Téléphone',
      'Email',
      'Sexe',
      'Type',
      'Niveau Étude',
      'Établissement',
      'Classe',
      'Source infos',
      'Date Relance',
      'Observations Prospect',
      'Spécialités et intérêts',
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    int currentExcelRow = 4;
    int dataRowCounter = 0;

    // Loop through the standalone list passed from the UI parameter
    for (var pDetails in prospectsList) {
      final CellStyle rowStyle = (dataRowCounter % 2 == 0) ? normalStyle : zebraStyle;

      // Combine all specialities into one formatted string with line breaks
      String specialitiesFormatted = '';
      if (pDetails.specialities.isNotEmpty) {
        // Sort by order preference
        final sortedSpecs = List<SpecialityDetail>.from(pDetails.specialities)
          ..sort((a, b) => a.orderPreference.compareTo(b.orderPreference));
        
        // Format with line breaks: each speciality on a new line
        specialitiesFormatted = sortedSpecs.map((spec) {
          String commentPart = '';
          if (spec.commentaire != null && spec.commentaire!.isNotEmpty) {
            commentPart = ' - ${spec.commentaire}';
          }
          return '${spec.orderPreference}. ${spec.libelleSpecialite} (Niveau ${spec.niveau}/10)$commentPart';
        }).join('\n'); 
      } else {
        specialitiesFormatted = 'Aucune spécialité';
      }

      // Write one row per prospect with all specialities combined
      _writeExcelRow(
        sheet, 
        currentExcelRow, 
        pDetails, 
        specialitiesFormatted, 
        rowStyle
      );
      
      currentExcelRow++;
      dataRowCounter++;
    }

    // Set column widths for better readability
    _setColumnWidths(sheet, headers.length);

    return excel.encode();
  }

  /// Helper method to set column widths
  static void _setColumnWidths(Sheet sheet, int columnCount) {
    final Map<int, double> columnWidths = {
      0: 20, // Nom Prospect
      1: 15, // Téléphone
      2: 25, // Email
      3: 10, // Sexe
      4: 10, // Type
      5: 15, // Niveau Étude
      6: 25, // Établissement
      7: 15, // Classe
      8: 20, // Source infos
      9: 15, // Date Relance
      10: 25, // Observations Prospect
      11: 52, // Spécialités et intérêts
    };

    for (int i = 0; i < columnCount; i++) {
      final width = columnWidths[i] ?? 15;
      sheet.setColumnWidth(i, width);
    }
  }

  /// Refactored helper method with Source infos and combined specialities
  static void _writeExcelRow(
    Sheet sheet,
    int row,
    ProspectDetails pd,
    String specialitiesFormatted,
    CellStyle style,
  ) {
    final columns = [
      TextCellValue(pd.prosp.nomComplet),
      TextCellValue(pd.prosp.telephone),
      TextCellValue(pd.prosp.email ?? 'no_email'.tr),
      TextCellValue(pd.prosp.sexe),
      TextCellValue(pd.prosp.typeProspect),
      TextCellValue(pd.prosp.niveauEtude),
      TextCellValue(pd.etablissement.nomEtablissement),
      TextCellValue(pd.classe.libelleClasse.tr),
      TextCellValue(pd.prosp.source_infos),
      TextCellValue(pd.prosp.date_relance != null
          ? pd.prosp.date_relance!.toIso8601String().split('T')[0]
          : ''),
      TextCellValue(pd.prosp.commentaireGen ?? ''),
      TextCellValue(specialitiesFormatted.tr), 
    ];

    // Write all columns
    for (int colIndex = 0; colIndex < columns.length; colIndex++) {
      var cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: row));
      cell.value = columns[colIndex];
      cell.cellStyle = style;
    }
  }
}