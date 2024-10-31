import 'package:flutter/material.dart';
import 'screens/editor_screen.dart';

void main() {
  runApp(TextEditorApp());
}

class TextEditorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editor de Texto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: EditorScreen(),
    );
  }
}
