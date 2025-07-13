// lib/controllers/shopping_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // This import provides GetX's string extensions
import 'package:objectbox/objectbox.dart';
import '../objectbox.dart';
import '../models/shopping_item.dart';


// GetX Controller for State Management
class ShoppingController extends GetxController {
  late final Box<ShoppingItem> _shoppingItemBox;
  var shoppingList = <ShoppingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _shoppingItemBox = objectbox.box<ShoppingItem>();
    _loadShoppingList();
  }

  void _loadShoppingList() {
    shoppingList.assignAll(_shoppingItemBox.getAll());
    debugPrint('Loaded ${shoppingList.length} items from ObjectBox.');
  }

  void addItem(String command) {
    debugPrint('Command received by addItem: "$command"');

    final addRegex = RegExp(
        r"(.+?)[,]?\s*(\d+(?:\.\d+)?)\s*(kg|gram|g|litre|liter|litres|liters|l)",
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
      String productUnit = match.group(3)?.trim() ?? '';

      debugPrint('Raw group 1 (productName): "${match.group(1)}"');
      debugPrint('Raw group 2 (productQuantity): "${match.group(2)}"');
      debugPrint('Raw group 3 (productUnit): "${match.group(3)}"');
      debugPrint('Trimmed productName var: "${productName}"');
      debugPrint('Trimmed productQuantity var: "${productQuantity}"');
      debugPrint('Trimmed productUnit var: "${productUnit}"');

      if (productName.isNotEmpty && productQuantity != '0' && productUnit.isNotEmpty) {
        final newItem = ShoppingItem(
          name: productName.capitalize!, // Use GetX's capitalize!
          quantity: '$productQuantity $productUnit',
        );
        _shoppingItemBox.put(newItem);
        _loadShoppingList();

        Get.snackbar(
          "Item Added",
          "${productName.capitalize!} ($productQuantity $productUnit) added to list.", // Use GetX's capitalize!
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

  void removeItem(int index) {
    if (index >= 0 && index < shoppingList.length) {
      final itemToRemove = shoppingList[index];
      final removedItemName = itemToRemove.name;

      _shoppingItemBox.remove(itemToRemove.id);
      _loadShoppingList();

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

// REMOVE THE ENTIRE EXTENSION BLOCK BELOW THIS LINE
// extension StringExtension on String {
//   String capitalizeFirst() {
//     if (isEmpty) return '';
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }