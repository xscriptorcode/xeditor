import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart' as quill;
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

  // Método para establecer el contenido en el área de edición
  void setContent(String content) {
    // Convierte el contenido a Delta para que Quill pueda interpretarlo
    final delta = quill.Delta()..insert(content + "\n");

    // Aplica el Delta al controlador de Quill para actualizar el contenido
    quillController.compose(
      delta,
      quillController.selection,
      quill.ChangeSource.local, // Usa ChangeSource.local en minúsculas
    );
  }

  void dispose() {
    quillController.dispose();
    pdfController.dispose();
    focusNode.dispose();
  }
}
