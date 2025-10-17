// Import statements go at the top
import 'package:flutter/material.dart';
import 'pages/test_page.dart'; // your login page widget

// Entry point of the app
void main() {
  runApp(const MyApp());
}

// MyApp is a StatelessWidget that wraps your whole app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mamatyp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // This is the first page that will be shown
      home: const TestPage(),
    );
  }
}
