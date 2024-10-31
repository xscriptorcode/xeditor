import 'package:flutter/material.dart';
import 'editor_layout.dart';
import 'editor_controller.dart';
import 'document_manager.dart';
import 'pdf_viewer.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorArea extends StatefulWidget {
  @override
  _EditorAreaState createState() => _EditorAreaState();
}

class _EditorAreaState extends State<EditorArea> {
  void openPdfViewer(String pdfPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewer(pdfPath: pdfPath),
      ),
    );
  }

  late EditorController _editorController;
  late DocumentManager _documentManager;

  @override
  void initState() {
    super.initState();
    _editorController = EditorController();
    _documentManager = DocumentManager(_editorController);
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditorLayout(
      editorController: _editorController,
      customButtons: [
        quill.QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.save),
          tooltip: 'Guardar',
          onPressed: _documentManager.saveDocument,
        ),
        quill.QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.save_as),
          tooltip: 'Guardar como',
          onPressed: _documentManager.saveDocumentAs,
        ),
        quill.QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.folder_open),
          tooltip: 'Abrir',
          onPressed: () async {
            await _documentManager.openDocument();
            setState(() {}); // Actualiza la UI con el nuevo nombre del documento
          },
        ),
      ],
          title: _editorController.documentName.isNotEmpty
          ? "${_editorController.documentName}${_editorController.fileFormat.isNotEmpty ? '.${_editorController.fileFormat}' : ''}"
          : "Nuevo Documento*",

            onOpenPdfViewer: () => openPdfViewer(_editorController.filePath ?? ''),
          );
  }
}
