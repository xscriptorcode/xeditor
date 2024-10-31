import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:docx_template/docx_template.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;
import 'package:xeditor/widgets/editor_controller.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdfx/pdfx.dart' as pdfx;

class DocumentManager {
  final EditorController editorController;

  DocumentManager(this.editorController);

  Future<void> saveDocument() async {
    final json = jsonEncode(editorController.quillController.document.toDelta().toJson());

    if (editorController.filePath != null) {
      final file = File(editorController.filePath!);
      await file.writeAsString(json);

      editorController.isSaved = true;
      print('Documento sobreescrito en: ${editorController.filePath}');
    } else {
      await saveDocumentAs();
    }
  }

  Future<void> saveDocumentAs() async {
    String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar documento como',
      fileName: 'MiDocumento.json',
      allowedExtensions: ['json'],
      type: FileType.custom,
    );

    if (outputFilePath != null) {
      final file = File(outputFilePath);
      final json = jsonEncode(editorController.quillController.document.toDelta().toJson());
      await file.writeAsString(json);

      editorController.filePath = outputFilePath;
      editorController.documentName = outputFilePath.split('/').last.split('.').first;
      editorController.fileFormat = ".json";
      editorController.isSaved = true;

      print('Documento guardado como JSON en: ${editorController.filePath}');
    }
  }

  Future<void> saveDocumentAsDocx() async {
    final docxTemplate = await rootBundle.load('assets/template.docx');
    final bytes = docxTemplate.buffer.asUint8List();
    final docx = await DocxTemplate.fromBytes(bytes);

    Content content = Content();
    content.add(TextContent('header', editorController.quillController.document.toPlainText()));

    final docGenerated = await docx.generate(content);
    if (docGenerated != null) {
      String? outputFilePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Guardar documento como DOCX',
        fileName: 'MiDocumento.docx',
        allowedExtensions: ['docx'],
        type: FileType.custom,
      );

      if (outputFilePath != null) {
        final file = File(outputFilePath);
        await file.writeAsBytes(docGenerated);
        editorController.documentName = outputFilePath.split('/').last.split('.').first;
        editorController.filePath = outputFilePath;
        editorController.fileFormat = ".docx";
        editorController.isSaved = true;
      }
    }
  }

  Future<void> saveDocumentAsPdf() async {
    final pdf = syncfusion.PdfDocument();
    final page = pdf.pages.add();
    page.graphics.drawString(
      editorController.quillController.document.toPlainText(),
      syncfusion.PdfStandardFont(syncfusion.PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
    );

    String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar documento como PDF',
      fileName: 'MiDocumento.pdf',
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (outputFilePath != null) {
      final file = File(outputFilePath);
      await file.writeAsBytes(pdf.saveSync());

      pdf.dispose();

      editorController.filePath = outputFilePath;
      editorController.documentName = outputFilePath.split('/').last.split('.').first;
      editorController.fileFormat = ".pdf";
      editorController.isSaved = true;

      print('Documento guardado como PDF en: ${editorController.filePath}');
    } else {
      print('Guardar como PDF cancelado');
    }
  }

  Future<void> openDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'docx', 'pdf', 'doc'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final extension = result.files.single.extension;

      if (extension == 'json') {
        final jsonString = await file.readAsString();
        final doc = quill.Document.fromJson(jsonDecode(jsonString));
        editorController.quillController.document = doc;
        editorController.documentName = result.files.single.name.split('.').first;
        editorController.filePath = result.files.single.path!;
        editorController.fileFormat = ".json";
        editorController.isSaved = true;
      } else if (extension == 'docx') {
        print('Abrir archivo DOCX: ${result.files.single.path}');
      } else if (extension == 'pdf') {
        editorController.pdfController.loadDocument(pdfx.PdfDocument.openFile(result.files.single.path!));
      }
      print('Documento cargado desde: ${editorController.filePath}');
    } else {
      print('No se seleccionó ningún archivo');
    }
  }
}
