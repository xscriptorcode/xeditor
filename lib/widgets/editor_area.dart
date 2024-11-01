import 'package:flutter/material.dart';
import 'package:xeditor/services/docx_reader.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewer(pdfPath: pdfPath),
      ),
    );
  }

  late EditorController _editorController;
  late DocumentManager _documentManager;
  bool isDocumentOpen = false;
  String? path;
  String docxContent = "Cargando...";

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

  Future<void> loadDocxContent(String filePath) async {
    final reader = DocxReader();
    final content = await reader.readDocxText(filePath);
    setState(() {
      docxContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: EditorLayout(
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

                  if (isDocumentOpen && path != null && path!.endsWith('.docx')) {
                    await loadDocxContent(path!);
                  } else {
                    // Manejar otros tipos de archivos.
                  }
                },
              ),
            ],
            title: _editorController.documentName.isNotEmpty
                ? "${_editorController.documentName}${_editorController.fileFormat.isNotEmpty ? '.${_editorController.fileFormat}' : ''}"
                : "Nuevo Documento*",
            onOpenPdfViewer: () => openPdfViewer(_editorController.filePath ?? ''),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(docxContent),
            ),
          ),
        ),
      ],
    );
  }
}
