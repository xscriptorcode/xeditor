// widgets/editor_layour.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'editor_controller.dart';

class EditorLayout extends StatelessWidget {
  final EditorController editorController;
  final List<quill.QuillToolbarCustomButtonOptions> customButtons;
  final VoidCallback onOpenPdfViewer;

  const EditorLayout({super.key, 
    required this.editorController,
    required this.customButtons,
    required this.onOpenPdfViewer, required String title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editorController.isSaved
            ? "${editorController.documentName}${editorController.fileFormat}"
            : "${editorController.documentName} *"),
      ),
      body: Column(
        children: [
          quill.QuillToolbar.simple(
            controller: editorController.quillController,
            configurations: quill.QuillSimpleToolbarConfigurations(
              customButtons: customButtons,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: quill.QuillEditor.basic(
                controller: editorController.quillController,
                focusNode: editorController.focusNode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
