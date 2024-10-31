import 'package:get/get.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:morning_buddies/utils/time_service.dart';

class AlertGameService {
  final TimeService _timeService = TimeService();
  bool _isGameCompleted = false; // Completion flag

  // HH : MM : SS 형식의 DATETIME 객체로 받아올 예정
  String targetTime = "12:59:00";

  DateTime convertToDateTime(String targetTime) {
    DateTime now = DateTime.now();
    List<String> timeParts = targetTime.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0; // 초 부분 처리

    return DateTime(now.year, now.month, now.day, hour, minute, second);
  }

  late DateTime convertedTargetTime = convertToDateTime(targetTime);

  void doAlertAction() {
    if (!_isGameCompleted) {
      DateTime now = DateTime.now();

      // 목표 시간이 현재와 일치하거나 이후인 경우에만 실행
      if (_timeService.isTargetTime(convertedTargetTime) ||
          now.isBefore(convertedTargetTime)) {
        _timeService.alarmAction(convertedTargetTime, _navigateToGameScreen);
      }
    }
  }

  void _navigateToGameScreen() {
    if (!_isGameCompleted) {
      // Check again to prevent double navigation
      Get.offAll(const GameStart());
      _isGameCompleted = true; // Set completion flag to true
    }
  }

  void markGameAsCompleted() {
    _isGameCompleted = true;
  }
}
