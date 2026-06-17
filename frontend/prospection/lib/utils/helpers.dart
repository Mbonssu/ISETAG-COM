
import '../models/fiche.dart';
import 'package:http/http.dart' as http;

class Helper {
  // final context = widget.context;
  static Future<void> _showExportOptions(Fiche fiche) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // showModalBottomSheet(
    //   context: context,
    //   shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    //   backgroundColor: Colors.white,
    //   builder: (context) => SafeArea(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const SizedBox(height: 12),
    //         Container(
    //             width: 40,
    //             height: 4,
    //             decoration: BoxDecoration(
    //                 color: Colors.grey.shade300,
    //                 borderRadius: BorderRadius.circular(2))),
    //         const SizedBox(height: 16),
    //         const Text('Fiche enregistrée avec succès !',
    //             style: TextStyle(
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //                 color: Color(0xFF2E7D32))),
    //         const SizedBox(height: 8),
    //         const Text('Souhaitez-vous exporter la fiche ?',
    //             style: TextStyle(fontSize: 14, color: Colors.grey)),
    //         const Divider(height: 24),
    //         ListTile(
    //           leading: Container(
    //               padding: const EdgeInsets.all(8),
    //               decoration: BoxDecoration(
    //                   color: Colors.red.shade50,
    //                   borderRadius: BorderRadius.circular(12)),
    //               child: Icon(Icons.picture_as_pdf,
    //                   color: Colors.red.shade700, size: 24)),
    //           title: const Text('Aperçu PDF'),
    //           subtitle: const Text('Visualiser avant d\'exporter'),
    //           trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             await ExportService.previewFichePDF(fiche);
    //           },
    //         ),
    //         ListTile(
    //           leading: Container(
    //               padding: const EdgeInsets.all(8),
    //               decoration: BoxDecoration(
    //                   color: Colors.red.shade50,
    //                   borderRadius: BorderRadius.circular(12)),
    //               child: Icon(Icons.picture_as_pdf,
    //                   color: Colors.red.shade700, size: 24)),
    //           title: const Text('Exporter en PDF'),
    //           subtitle: const Text('Télécharger ou partager la fiche'),
    //           trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             await _exportAndSharePDF(fiche);
    //           },
    //         ),
    //         ListTile(
    //           leading: Container(
    //               padding: const EdgeInsets.all(8),
    //               decoration: BoxDecoration(
    //                   color: const Color(0xFF2E7D32).withOpacity(0.1),
    //                   borderRadius: BorderRadius.circular(12)),
    //               child: const Icon(Icons.table_chart,
    //                   color: Color(0xFF2E7D32), size: 24)),
    //           title: const Text('Aperçu Excel'),
    //           subtitle: const Text('Visualiser avant d\'exporter'),
    //           trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             await ExportService.previewFicheExcel(fiche);
    //           },
    //         ),
    //         ListTile(
    //           leading: Container(
    //               padding: const EdgeInsets.all(8),
    //               decoration: BoxDecoration(
    //                   color: const Color(0xFF2E7D32).withOpacity(0.1),
    //                   borderRadius: BorderRadius.circular(12)),
    //               child: const Icon(Icons.table_chart,
    //                   color: Color(0xFF2E7D32), size: 24)),
    //           title: const Text('Exporter en Excel'),
    //           subtitle: const Text('Télécharger ou partager la fiche'),
    //           trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    //           onTap: () async {
    //             Navigator.pop(context);
    //             await _exportAndShareExcel(fiche);
    //           },
    //         ),
    //         const SizedBox(height: 8),
    //         TextButton(
    //             onPressed: () => _navigateBack(),
    //             child: const Text('Plus tard', style: TextStyle(fontSize: 14))),
    //         const SizedBox(height: 12),
    //       ],
    //     ),
    //   ),
    // );
  }

  Future<void> _exportAndShareExcel(Fiche fiche) async {
    _showLoadingDialog('Génération du fichier Excel...');
    // final file = await ExportService.exportFicheToExcel(fiche);
    // if (mounted) Navigator.pop(context);
    // if (file != null && mounted) {
    //   await ExportService.shareFile(file, file.path.split('/').last);
    //   _showSnackBar('Excel exporté avec succès !', const Color(0xFF2E7D32));
    //   _navigateBack();
    // } else {
    //   _showSnackBar('Erreur lors de l\'export Excel', Colors.red);
    // }
  }

  void _showLoadingDialog(String message) {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => AlertDialog(
    //     content: Column(mainAxisSize: MainAxisSize.min, children: [
    //       const CircularProgressIndicator(),
    //       const SizedBox(height: 16),
    //       Text(message)
    //     ]),
    //   ),
    // );
  }

  Future<bool> canReachServer() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://your-api.com/ping'),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
