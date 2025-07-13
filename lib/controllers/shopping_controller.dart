// lib/controllers/shopping_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import for Colors and Theme

// Item Model
class ShoppingItem {
  final String name;
  final String quantity;

  ShoppingItem({required this.name, required this.quantity}); // Corrected constructor if it was quantityValue
}

// GetX Controller for State Management
class ShoppingController extends GetxController {
  var shoppingList = <ShoppingItem>[].obs;

  /// Adds a new item to the shopping list based on a voice command.
  /// The command is expected to be in the format "[name] [quantity] kg".
  void addItem(String command) {
    debugPrint('Command received by addItem: "$command"');

    // TEMPORARY: Test a simpler regex (you can remove this after confirming the fix)
    final testRegex = RegExp(r"10 kg", caseSensitive: false);
    if (testRegex.hasMatch(command)) {
      debugPrint('SUCCESS: "10 kg" found in command!');
    } else {
      debugPrint('FAILURE: "10 kg" NOT found in command.');
    }

    // Corrected Regex to capture product name and quantity in kg
    // Updated to handle decimal quantities like "10.5"
    final addRegex = RegExp(
        r"(.+?)[,]?\s*(\d+(?:\.\d+)?)\s*kg", // <--- CHANGED THIS LINE
        caseSensitive: false);
    final totalRegex = RegExp(r"total", caseSensitive: false);

    if (totalRegex.hasMatch(command)) {
      Get.snackbar(
        "Total Command Recognized",
        "Calculating total (feature to be implemented).",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
      );
      return;
    }

    final match = addRegex.firstMatch(command);
    if (match != null) {
      String productName = match.group(1)?.trim() ?? '';
      String productQuantityKg = match.group(2)?.trim() ?? '0'; // Added .trim() for quantity just in case

      debugPrint('Regex matched! Product Name: "${productName}" Quantity: "${productQuantityKg}"');

      // Basic validation for extracted data
      if (productName.isNotEmpty && productQuantityKg != '0') {
        shoppingList.add(ShoppingItem(
          name: productName.toString(), // Applied capitalizeFirst here for better display
          quantity: '$productQuantityKg kg',
        ));
        Get.snackbar(
          "Item Added",
          "${productName.toString()} ($productQuantityKg kg) added to list.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        debugPrint('Validation failed: productName empty or productQuantityKg is "0"');
        _showInvalidCommandSnackbar();
      }
    } else {
      debugPrint('Regex failed to match the command: "$command"');
      _showInvalidCommandSnackbar();
    }
  }

  /// Removes an item from the shopping list at the specified index.
  void removeItem(int index) {
    if (index >= 0 && index < shoppingList.length) {
      final removedItemName = shoppingList[index].name;
      shoppingList.removeAt(index);
      Get.snackbar(
        "Item Removed",
        "$removedItemName removed from list.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void _showInvalidCommandSnackbar() {
    Get.snackbar(
      "Invalid Command",
      "Please say '[item name] [quantity] kg' (e.g., 'onion 1 kg')",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }
}

// Extension to capitalize first letter (for better display)
extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return '';
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}