import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart';

class DocxReader {
  Future<String> readDocxText(String filePath) async {
    try {
      // Leer el archivo .docx como bytes
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      // Descomprimir el archivo .docx
      final archive = ZipDecoder().decodeBytes(bytes);

      // Buscar el archivo word/document.xml dentro del archivo descomprimido
      final documentFile = archive.files.firstWhere(
        (file) => file.name == 'word/document.xml',
        orElse: () => throw Exception('Archivo document.xml no encontrado en el .docx'),
      );

      // Leer el contenido XML de document.xml
      final documentContent = documentFile.content as List<int>;
      final xmlString = String.fromCharCodes(documentContent);

      // Parsear el XML y extraer el texto
      final documentXml = XmlDocument.parse(xmlString);
      final textElements = documentXml.findAllElements('w:t');

      // Concatenar el texto encontrado
      final textBuffer = StringBuffer();
      for (var element in textElements) {
        textBuffer.write(element.text);
        textBuffer.write(" "); // Añadir espacio entre palabras
      }

      return textBuffer.toString();
    } catch (e) {
      print("Error al leer el archivo .docx: $e");
      return "No se pudo leer el archivo .docx";
    }
  }
}
