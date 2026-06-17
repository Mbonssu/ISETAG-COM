import 'package:excel/excel.dart';
import '../models/fiche.dart';
import '../models/prospectData.dart';

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

    // Zebra pattern styling for alternating data lines to add a premium touch
    final CellStyle zebraStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'), // backgroundGrey
      fontColorHex: ExcelColor.fromHexString('#1A1A1A'), // textPrimary
      fontFamily: getFontFamily(FontFamily.Arial),
      verticalAlign: VerticalAlign.Center,
    );

    final CellStyle normalStyle = CellStyle(
      backgroundColorHex:
          ExcelColor.fromHexString('#FFFFFF'), // backgroundWhite
      fontColorHex: ExcelColor.fromHexString('#1A1A1A'), // textPrimary
      fontFamily: getFontFamily(FontFamily.Arial),
      verticalAlign: VerticalAlign.Center,
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
      'Date Relance',
      'Observations Prospect',
      'Spécialité Préf.',
      'Ordre Pref',
      'Niveau Choisi',
      'Note Spécialité'
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    int currentExcelRow = 4;
    int dataRowCounter = 0; // Tracks data lines for zebra striping colors

    // Loop through the standalone list passed from the UI parameter
    for (var pDetails in prospectsList) {
      final CellStyle rowStyle =
          (dataRowCounter % 2 == 0) ? normalStyle : zebraStyle;

      // If the prospect hasn't selected any specialities yet, print a row with blanks for speciality columns
      if (pDetails.specialities.isEmpty) {
        _writeExcelRow(sheet, currentExcelRow, pDetails, null, rowStyle);
        currentExcelRow++;
        dataRowCounter++;
      } else {
        // Create a unique row for every targeted speciality preference object
        for (var spec in pDetails.specialities) {
          _writeExcelRow(sheet, currentExcelRow, pDetails, spec, rowStyle);
          currentExcelRow++;
          dataRowCounter++;
        }
      }
    }

    return excel.encode();
  }

  /// Refactored helper method to accept the proper styling context per row entry
  static void _writeExcelRow(
    Sheet sheet,
    int row,
    ProspectDetails pd,
    SpecialityDetail? spec,
    CellStyle style,
  ) {
    final columns = [
      TextCellValue(pd.prosp.nomComplet),
      TextCellValue(pd.prosp.telephone),
      TextCellValue(pd.prosp.email ?? ''),
      TextCellValue(pd.prosp.sexe),
      TextCellValue(pd.prosp.typeProspect),
      TextCellValue(pd.prosp.niveauEtude),
      TextCellValue(pd.etablissement),
      TextCellValue(pd.classe),
      TextCellValue(pd.prosp.date_relance != null
          ? pd.prosp.date_relance!.toIso8601String().split('T')[0]
          : ''),
      TextCellValue(pd.prosp.commentaireGen ?? ''),
    ];

    // Write primary prospect metadata columns
    for (int colIndex = 0; colIndex < columns.length; colIndex++) {
      var cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: row));
      cell.value = columns[colIndex];
      cell.cellStyle = style;
    }

    // Write nested Speciality details variables into columns 10 to 13
    if (spec != null) {
      final specColumns = {
        10: TextCellValue(spec.libelleSpecialite),
        11: TextCellValue('#${spec.orderPreference}'),
        12: TextCellValue('Niveau ${spec.niveau}/10'),
        13: TextCellValue(spec.commentaire ?? ''),
      };

      specColumns.forEach((colIndex, cellValue) {
        var cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: row));
        cell.value = cellValue;
        cell.cellStyle = style;
      });
    } else {
      // Fill the remaining columns with blanks if there are no specialities, maintaining formatting
      for (int colIndex = 10; colIndex <= 13; colIndex++) {
        var cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: row));
        cell.value = TextCellValue('');
        cell.cellStyle = style;
      }
    }
  }
}
