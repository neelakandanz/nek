// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nek/screens/shopping_list_page.dart';
import 'package:nek/objectbox.dart'; // Import your ObjectBox initialization file

void main() async {
  // Ensure Flutter widgets are initialized before accessing native code for paths
  WidgetsFlutterBinding.ensureInitialized();
  await initializeObjectBox(); // Initialize ObjectBox

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Voice Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 4,
        ),
      ),
      home: const ShoppingListPage(),
    );
  }
}