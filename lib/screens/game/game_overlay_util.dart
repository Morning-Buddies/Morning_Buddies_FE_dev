import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class OverlayUtil {
  static void showCompletionOverlay(
      BuildContext context, Function onReturnToMain) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/alert_logo.png'),
              ),
              const Text(
                "미션 성공🎉",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyles.secondaryOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(369, 48),
                ),
                onPressed: () {
                  onReturnToMain();
                },
                child: const Text("Lock 해제"),
              ),
            ],
          ),
        );
      },
    );
  }
}
