import 'package:flutter/material.dart';

class OverlayUtil {
  static void showCompletionOverlay(
      BuildContext context, Function onReturnToMain) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Puzzle Completed!"),
          content:
              const Text("Congratulations! You have completed the puzzle."),
          actions: [
            ElevatedButton(
              onPressed: () {
                onReturnToMain(); // Trigger the function passed to return to the main screen
              },
              child: const Text("Return to Main"),
            ),
          ],
        );
      },
    );
  }
}
