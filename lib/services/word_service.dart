import 'dart:io';
import 'package:docx_template/docx_template.dart';

class WordService {
  Future<void> generateDocxFromTemplate(String templatePath, String outputPath) async {
    try {
      final templateFile = File(templatePath);
      
      if (!await templateFile.exists()) {
        print("Error: La plantilla no existe en la ruta especificada.");
        return;
      }

      // Lee la plantilla como bytes
      final templateBytes = await templateFile.readAsBytes();
      final docx = await DocxTemplate.fromBytes(templateBytes);

      if (docx == null) {
        print("Error: No se pudo cargar la plantilla DOCX.");
        return;
      }

      // Ejemplo de contenido para rellenar en el documento
      final content = Content();


      // Genera el documento nuevo con el contenido especificado
      final generatedBytes = await docx.generate(content);
      if (generatedBytes == null) {
        print("Error: No se pudo generar el documento.");
        return;
      }

      // Guarda el documento generado en la ubicación especificada
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(generatedBytes);

      print("Documento generado correctamente en $outputPath");

    } catch (e) {
      print("Error al generar el documento: $e");
    }
  }
}
