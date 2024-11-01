import 'package:flutter/material.dart';
import 'package:xeditor/services/doc_reader.dart';
import 'editor_layout.dart';
import 'editor_controller.dart';
import 'document_manager.dart';
import 'pdf_viewer.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorArea extends StatefulWidget {
  const EditorArea({super.key});

  @override
  _EditorAreaState createState() => _EditorAreaState();
}

class _EditorAreaState extends State<EditorArea> {
  void openPdfViewer(String pdfPath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Visor PDF"),
        content: Container(
          width: double.maxFinite,
          child: PdfViewerPage(pdfPath: pdfPath),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  late EditorController _editorController;
  late DocumentManager _documentManager;
  bool isDocumentOpen = false;
  String? path;

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

  Future<void> loadDocumentContent(String filePath) async {
    final reader = DocumentReader();
    final content = await reader.readDocument(filePath);
    setState(() {
      _editorController.setContent(content); // Cargar contenido en el área de edición
    });
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
            path = _editorController.filePath;
            setState(() {
              isDocumentOpen = path != null;
            });

            if (isDocumentOpen && path != null) {
              if (path!.endsWith('.pdf')) {
                openPdfViewer(path!);
              } else {
                await loadDocumentContent(path!);
              }
            }
          },
        ),
        quill.QuillToolbarCustomButtonOptions(
          icon: Icon(Icons.picture_as_pdf),
          tooltip: 'Exportar a PDF',
          onPressed: () {
            // Lógica para exportar el documento actual a PDF
          },
        ),
      ],
      title: _editorController.documentName.isNotEmpty
          ? "${_editorController.documentName}${_editorController.fileFormat.isNotEmpty ? '.${_editorController.fileFormat}' : ''}"
          : "Nuevo Documento*", onOpenPdfViewer: () {  },
    );
  }
}
