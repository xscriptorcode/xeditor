import 'package:flutter/material.dart';
import '../widgets/editor_area.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({Key? key}) : super(key: key);

  void _handleMenuSelection(String menu) {
    // Manejo de selección en la barra de menú
    print("Menú seleccionado: $menu");
    // Aquí implementaré la lógica de las opciones
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         // CustomMenuBar(onMenuSelected: _handleMenuSelection), // Callback añadido
          Expanded(child: EditorArea()),
        ],
      ),
    );
  }
}
