// lib/controllers/shopping_controller.dart
import 'package:get/get.dart';

// Item Model
class ShoppingItem {
  final String name;
  final String quantity;

  ShoppingItem({required this.name, required this.quantity});
}

// GetX Controller for State Management
class ShoppingController extends GetxController {
  // Observable list of ShoppingItem. Changes to this list will automatically
  // update widgets wrapped with Obx or GetX.
  var shoppingList = <ShoppingItem>[].obs;

  /// Adds a new item to the shopping list based on a voice command.
  /// The command is expected to be in the format "item quantity" (e.g., "onion 1 kg").
  void addItem(String command) {
    final parts = command.split(' ');
    if (parts.length >= 2) {
      String name = parts[0];
      String quantity = parts.sublist(1).join(' '); // Combine remaining parts for quantity

      // You can add more sophisticated parsing logic here
      // For example, to handle specific units or more complex phrases:
      // if (parts.length > 2) {
      //   name = parts[0];
      //   quantity = "${parts[1]} ${parts[2]}"; // e.g., "1 kg"
      // } else {
      //   name = parts[0];
      //   quantity = parts[1]; // e.g., "1"
      // }

      shoppingList.add(ShoppingItem(name: name, quantity: quantity));
    } else {
      // Show a snackbar or alert for invalid commands
      Get.snackbar(
        "Invalid Command",
        "Please say 'item quantity' (e.g., 'onion 1 kg')",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  /// Removes an item from the shopping list at the specified index.
  void removeItem(int index) {
    if (index >= 0 && index < shoppingList.length) {
      shoppingList.removeAt(index);
    }
  }
}