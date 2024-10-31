// widgets/menu_bar.dart

import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  final Function(String) onMenuSelected; // Callback para manejar las selecciones

  CustomMenuBar({required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildMenuButton("Home"),
          _buildMenuButton("Insert"),
          _buildMenuButton("View"),
          _buildMenuButton("Tools"),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String label) {
    return TextButton(
      onPressed: () => onMenuSelected(label), // Pasar el menú seleccionado al callback
      child: Text(label, style: TextStyle(color: Colors.black87)),
    );
  }
}
