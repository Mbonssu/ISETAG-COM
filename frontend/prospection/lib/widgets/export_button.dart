import 'package:flutter/material.dart';
import '../services/export_service.dart';
import '../models/fiche.dart';

class ExportFicheButton extends StatefulWidget {
  final Fiche fiche;
  final String? title;
  
  const ExportFicheButton({
    super.key,
    required this.fiche,
    this.title,
  });

  @override
  State<ExportFicheButton> createState() => _ExportFicheButtonState();
}

class _ExportFicheButtonState extends State<ExportFicheButton> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.ios_share, color: Colors.white),
      onSelected: (value) async {
        setState(() {
          _isExporting = true;
        });
        
        try {
          if (value == 'excel') {
            await _exportToExcel();
          } else if (value == 'pdf') {
            await _exportToPDF();
          }
        } finally {
          if (mounted) {
            setState(() {
              _isExporting = false;
            });
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'excel',
          child: Row(
            children: [
              Icon(Icons.table_chart, color: Color(0xFF2E7D32), size: 22),
              SizedBox(width: 12),
              Text('Exporter la fiche en Excel'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red, size: 22),
              SizedBox(width: 12),
              Text('Exporter la fiche en PDF'),
            ],
          ),
        ),
      ],
      child: _isExporting
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.ios_share, color: Colors.white, size: 24),
    );
  }
  
  Future<void> _exportToExcel() async {
    final file = await ExportService.exportFicheToExcel(widget.fiche);
    if (file != null && mounted) {
      await ExportService.shareFile(file, file.path.split('/').last);
      _showSuccessDialog('Excel', widget.fiche.prospects.length);
    } else {
      _showErrorDialog();
    }
  }
  
  Future<void> _exportToPDF() async {
    final file = await ExportService.exportFicheToPDF(widget.fiche);
    if (file != null && mounted) {
      await ExportService.shareFile(file, file.path.split('/').last);
      _showSuccessDialog('PDF', widget.fiche.prospects.length);
    } else {
      _showErrorDialog();
    }
  }
  
  void _showSuccessDialog(String format, int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 50),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Export réussi !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'La fiche contenant $count prospect${count > 1 ? 's' : ''} a été exportée au format $format.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(Icons.error, color: Colors.red, size: 50),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Erreur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Une erreur est survenue lors de l\'exportation de la fiche.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}