// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nek/screens/shopping_list_page.dart'; // Import your screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp for GetX features
      title: 'Voice Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 4, // Add a subtle shadow to the app bar
        ),
      ),
      home: const ShoppingListPage(), // Your main screen
    );
  }
}