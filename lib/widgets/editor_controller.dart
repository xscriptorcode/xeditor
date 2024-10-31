import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdfx/pdfx.dart' as pdfx;

class EditorController {
  final quill.QuillController quillController = quill.QuillController.basic();
  final FocusNode focusNode = FocusNode();
  late pdfx.PdfController pdfController;

  String documentName = "Nuevo documento";
  bool isSaved = false;
  String fileFormat = ".json";
  String? filePath;

  EditorController() {
    pdfController = pdfx.PdfController(
      document: pdfx.PdfDocument.openFile('path_to_pdf.pdf'),
    );
  }

  void dispose() {
    quillController.dispose();
    pdfController.dispose();
    focusNode.dispose();
  }
}
