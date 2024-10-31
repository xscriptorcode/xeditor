import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'editor_controller.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DocumentManager {
  final EditorController editorController;

  DocumentManager(this.editorController);

  Future<void> saveDocument() async {
    final content = editorController.quillController.document.toPlainText();

    if (editorController.filePath != null) {
      final file = File(editorController.filePath!);
      await file.writeAsString(content);

      editorController.isSaved = true;
      print('Documento sobreescrito en: ${editorController.filePath}');
    } else {
      await saveDocumentAs();
    }
  }

  Future<void> saveDocumentAs() async {
    String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar documento',
      fileName: 'MiDocumento',
    );

    if (outputFilePath != null) {
      final file = File(outputFilePath);
      final content = editorController.quillController.document.toPlainText();
      await file.writeAsString(content);

      editorController.filePath = outputFilePath;

      // Separar el nombre del archivo y la extensión correctamente
      final nameParts = outputFilePath.split('/').last.split('.');
      if (nameParts.length > 1) {
        editorController.documentName = nameParts.sublist(0, nameParts.length - 1).join('.');
        editorController.fileFormat = '.' + nameParts.last;  // Aseguramos que tiene el punto
      } else {
        editorController.documentName = nameParts[0];
        editorController.fileFormat = '';  // No tiene extensión
      }
      editorController.isSaved = true;

      print('Documento guardado en: ${editorController.filePath}');
      print('Nombre del Documento: ${editorController.documentName}');
      print('Formato del Documento: ${editorController.fileFormat}');
    }
  }

  Future<void> openDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      editorController.filePath = result.files.single.path!;
      
      // Separar el nombre y extensión
      final nameParts = result.files.single.name.split('.');
      if (nameParts.length > 1) {
        editorController.documentName = nameParts.sublist(0, nameParts.length - 1).join('.');
        editorController.fileFormat = '.' + nameParts.last;  // Aseguramos que tiene el punto
      } else {
        editorController.documentName = nameParts[0];
        editorController.fileFormat = '';  // No tiene extensión
      }
      editorController.isSaved = true;

      print('Documento cargado desde: ${editorController.filePath}');
      print('Nombre del Documento: ${editorController.documentName}');
      print('Formato del Documento: ${editorController.fileFormat}');

      try {
        if (editorController.fileFormat == '.json') {
          final jsonString = await file.readAsString();
          final doc = quill.Document.fromJson(jsonDecode(jsonString));
          editorController.quillController.document = doc;
        } else {
          final content = await file.readAsString();
          editorController.quillController.document = quill.Document()..insert(0, content);
        }
      } catch (e) {
        print('Error al abrir el archivo: $e');
      }
    } else {
      print('No se seleccionó ningún archivo');
    }
  }
}
