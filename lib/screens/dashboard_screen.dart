// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nek/screens/shopping_list_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    // Navigate to the ShoppingListPage when the card is tapped
                    Get.to(() => const ShoppingListPage());
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: Get.width * 0.8, // Adjust width as needed
                    height: 150, // Fixed height for the card
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mic,
                          size: 50,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Voice Shopping List',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Manage your shopping with voice commands',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // You can add more cards or dashboard elements here
              const SizedBox(height: 20),
              Text(
                'Welcome to your Nek App!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}