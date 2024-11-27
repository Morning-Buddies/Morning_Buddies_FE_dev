import 'package:get/get.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:morning_buddies/service/notification/notification_helper.dart';
import 'package:morning_buddies/utils/time_service.dart';

class AlertGameService {
  final TimeService _timeService = TimeService();
  bool _isGameCompleted = false; // Completion flag

  // HH : MM : SS 형식의 DATETIME 객체로 받아올 예정
  String targetTime = "16:51:00";

  DateTime convertToDateTime(String targetTime) {
    DateTime now = DateTime.now();
    List<String> timeParts = targetTime.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0; // 초 부분 처리

    return DateTime(now.year, now.month, now.day, hour, minute, second);
  }

  late DateTime convertedTargetTime = convertToDateTime(targetTime);

  void doAlertAction() async {
    if (!_isGameCompleted) {
      DateTime now = DateTime.now();

      if (_timeService.isTargetTime(convertedTargetTime) ||
          now.isBefore(convertedTargetTime)) {
        _timeService.alarmAction(convertedTargetTime, _navigateToGameScreen);
        NotificationHelper helper = NotificationHelper();
        await helper.scheduleNotification(convertedTargetTime); // 알림 예약
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
