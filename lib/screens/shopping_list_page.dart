// lib/screens/shopping_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../controllers/shopping_controller.dart'; // Import your controller

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  // Find or put the controller instance
  final ShoppingController shoppingController = Get.put(ShoppingController());
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This initializes the speech recognition.
  void _initSpeech() async {
    // Check if speech recognition is available and initialize it
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) => debugPrint('Speech status: $status'),
      onError: (error) => debugPrint('Speech error: $error'),
    );
    setState(() {}); // Update the UI to reflect if speech is enabled
  }

  /// Starts a speech recognition session.
  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: Get.deviceLocale?.languageCode ?? 'en_US', // Use device locale or default to English
      );
      setState(() {}); // Update UI to show listening state
    } else {
      Get.snackbar(
        "Speech Not Enabled",
        "Please grant microphone permission.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
    }
  }

  /// Stops the active speech recognition session.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {}); // Update UI to show not listening state
  }

  /// Callback when speech recognition results are available.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    if (result.finalResult) {
      // When the final result is received, add the item to the list
      shoppingController.addItem(_lastWords.toLowerCase()); // Convert to lowercase for consistent parsing
      _lastWords = ''; // Clear temporary words
      setState(() {}); // Update UI to clear displayed words
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Shopping List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            // Obx rebuilds its content whenever shoppingController.shoppingList changes
            child: Obx(
              () => shoppingController.shoppingList.isEmpty
                  ? Center(
                      child: Text(
                        _speechEnabled ? 'Tap the microphone to add items!' : 'Speech recognition is not available.',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: shoppingController.shoppingList.length,
                      itemBuilder: (context, index) {
                        final item = shoppingController.shoppingList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              item.name, // Capitalize the first letter of the item name
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              item.quantity,
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 24),
                              onPressed: () => shoppingController.removeItem(index),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              child: Text('${index + 1}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Display recognized words and microphone button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _speechToText.isListening
                      ? 'Listening: $_lastWords'
                      : _speechEnabled
                          ? 'Tap the microphone to speak...'
                          : 'Speech recognition not initialized.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                FloatingActionButton(
                  onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                  tooltip: _speechToText.isNotListening ? 'Start Listening' : 'Stop Listening',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 6,
                  child: Icon(
                    _speechToText.isNotListening ? Icons.mic : Icons.mic_off,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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