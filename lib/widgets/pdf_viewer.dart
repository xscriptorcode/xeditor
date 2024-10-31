import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

class PdfViewer extends StatelessWidget {
  final String pdfPath;

  PdfViewer({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    final pdfController = pdfx.PdfController(document: pdfx.PdfDocument.openFile(pdfPath));

    return Scaffold(
      appBar: AppBar(title: Text("Vista de PDF")),
      body: pdfx.PdfView(controller: pdfController),
    );
  }
}
