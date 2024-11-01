import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;

  const PdfViewerPage({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor de PDF'),
      ),
      body: PdfViewer.file(
        pdfPath, // Solo pasamos la ruta como cadena de texto
        params: const PdfViewerParams(
          minScale: 1.0,
          maxScale: 3.0,
        ),
      ),
    );
  }
}
