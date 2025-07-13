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
  final ShoppingController shoppingController = Get.put(ShoppingController());
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  // 1. Declare a ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    // 2. Add a listener to the shoppingList to trigger scroll when items are added
    // This is more robust than scrolling directly after addItem call
    shoppingController.shoppingList.listen((_) {
      // Ensure the UI has a chance to rebuild before trying to scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    // 3. Dispose the ScrollController when the widget is removed
    _scrollController.dispose();
    super.dispose();
  }

  /// This initializes the speech recognition.
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) => debugPrint('Speech status: $status'),
      onError: (error) => debugPrint('Speech error: $error'),
    );
    setState(() {});
  }

  /// Starts a speech recognition session.
  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: Get.deviceLocale?.languageCode ?? 'en_US',
      );
      setState(() {});
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
    setState(() {});
  }

  /// Callback when speech recognition results are available.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    if (result.finalResult) {
      shoppingController.addItem(_lastWords.toLowerCase());
      _lastWords = '';
      setState(() {});
      // The scrolling logic is now handled by the listener in initState
    }
  }

  // Removed: _addTestItemManually() method

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
                      // 4. Assign the ScrollController to the ListView.builder
                      controller: _scrollController,
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
                              item.name,
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
                // Removed the Row and the manual add button
                FloatingActionButton(
                  onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                  tooltip: _speechToText.isNotListening ? 'Start Listening' : 'Stop Listening',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 6,
                  // heroTag is no longer needed as there's only one FAB
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

// Ensure this extension is removed or handled if it causes ambiguity
// as discussed in previous turns with GetX's capitalize!
extension StringExtension on String {
    String capitalizeFirst() {
      if (isEmpty) return '';
      return "${this[0].toUpperCase()}${substring(1)}";
    }
}