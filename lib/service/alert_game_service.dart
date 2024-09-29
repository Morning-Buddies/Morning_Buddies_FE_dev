import 'package:get/get.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:morning_buddies/service/time_service.dart';

class AlertGameService {
  final TimeService _timeService = TimeService();
  bool _isGameCompleted = false; // Completion flag

  String targetTime = "14:27";

  DateTime convertToDateTime(String targetTime) {
    DateTime now = DateTime.now();
    List<String> timeParts = targetTime.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  late DateTime convertedTargetTime = convertToDateTime(targetTime);

  void doAlertAction() {
    if (!_isGameCompleted) {
      // Only navigate if the game is not completed
      _timeService.alarmAction(convertedTargetTime, _navigateToGameScreen);
    }
  }

  void _navigateToGameScreen() {
    if (!_isGameCompleted) {
      // Check again to prevent double navigation
      Get.offAll(const GameStart());
      _isGameCompleted = true; // Set completion flag to true
    }
  }
}
