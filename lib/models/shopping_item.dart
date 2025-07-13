// lib/models/shopping_item.dart
import 'package:objectbox/objectbox.dart'; // Import ObjectBox

@Entity() // ObjectBox annotation
class ShoppingItem {
  int id; // ObjectBox uses this as primary key
  final String name;
  final String quantity;

  ShoppingItem({this.id = 0, required this.name, required this.quantity});
}