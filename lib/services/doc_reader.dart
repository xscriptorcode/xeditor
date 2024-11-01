import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart';

class DocumentReader {
  Future<String> readTextFile(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      print("Error al leer el archivo de texto: $e");
      return "No se pudo leer el archivo de texto.";
    }
  }

  Future<String> readDocFile(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      // Implementación básica para archivos en formato RTF
      // Busca el texto entre las etiquetas de formato RTF como \par
      String content = String.fromCharCodes(bytes);
      content = content.replaceAll(RegExp(r'\\par'), '\n');
      content = content.replaceAll(RegExp(r'[{}\\]'), '');
      return content;
    } catch (e) {
      print("Error al leer el archivo DOC: $e");
      return "No se pudo leer el archivo DOC.";
    }
  }


Future<String> readDocxFile(String filePath) async {
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
      String xmlString;

      // Intentar decodificar usando UTF-8, si falla usa latin1
      try {
        xmlString = utf8.decode(documentContent);
      } catch (e) {
        xmlString = latin1.decode(documentContent);
      }

      // Parsear el XML y extraer el texto
      final documentXml = XmlDocument.parse(xmlString);
      final textElements = documentXml.findAllElements('w:t');

      // Concatenar el texto encontrado
      final textBuffer = StringBuffer();
      for (var element in textElements) {
        textBuffer.write(element.text);
        textBuffer.write(" ");
      }

      return textBuffer.toString();
    } catch (e) {
      print("Error al leer el archivo .docx: $e");
      return ""; // Devuelve una cadena vacía si falla
    }
  }


  Future<String> readDocument(String filePath) async {
    if (filePath.endsWith('.txt')) {
      return await readTextFile(filePath);
    } else if (filePath.endsWith('.docx')) {
      return await readDocxFile(filePath);
    } else if (filePath.endsWith('.doc')) {
      return await readDocFile(filePath);
    } else {
      return "Formato de archivo no soportado.";
    }
  }
}
