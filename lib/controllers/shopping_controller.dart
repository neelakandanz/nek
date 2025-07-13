// lib/controllers/shopping_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import for Colors and Theme

// Item Model
class ShoppingItem {
  final String name;
  final String quantity;

  ShoppingItem({required this.name, required this.quantity});
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

    // Corrected Regex to capture product name, quantity, and unit
    // Now includes 'litre', 'liter', 'litres', 'liters', and 'l'
    final addRegex = RegExp(
        r"(.+?)[,]?\s*(\d+(?:\.\d+)?)\s*(kg|gram|g|litre|liter|litres|liters|l)", // <--- CHANGED THIS LINE
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
      String productQuantity = match.group(2)?.trim() ?? '0';
      String productUnit = match.group(3)?.trim() ?? ''; // Capture the unit

      debugPrint('Raw group 1 (productName): "${match.group(1)}"');
      debugPrint('Raw group 2 (productQuantity): "${match.group(2)}"');
      debugPrint('Raw group 3 (productUnit): "${match.group(3)}"');
      debugPrint('Trimmed productName var: "${productName}"');
      debugPrint('Trimmed productQuantity var: "${productQuantity}"');
      debugPrint('Trimmed productUnit var: "${productUnit}"');

      // Basic validation for extracted data
      if (productName.isNotEmpty && productQuantity != '0' && productUnit.isNotEmpty) {
        shoppingList.add(ShoppingItem(
          name: productName.capitalize!,
          quantity: '$productQuantity $productUnit', // Use the captured unit
        ));
        Get.snackbar(
          "Item Added",
          "${productName.capitalize!} ($productQuantity $productUnit) added to list.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        debugPrint('Validation failed: productName empty, productQuantity is "0", or productUnit is empty');
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
      "Please say '[item name] [quantity] [unit]' (e.g., 'onion 1 kg' or 'water 2 litres')",
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