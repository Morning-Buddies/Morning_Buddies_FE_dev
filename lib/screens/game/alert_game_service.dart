import 'dart:async';
import 'package:get/get.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:morning_buddies/service/notification/notification_helper.dart';
import 'package:timezone/timezone.dart' as tz;

class AlertGameService {
  bool _isGameCompleted = false; // 게임 완료 여부
  final NotificationHelper _notificationHelper = NotificationHelper();

  String targetTime = "13:42:00";
  final seoul = tz.getLocation('Asia/Seoul');

  tz.TZDateTime convertToDateTime(String targetTime) {
    tz.TZDateTime now = tz.TZDateTime.now(seoul); // Timezone-aware 현재 시간
    List<String> timeParts = targetTime.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

    tz.TZDateTime targetDateTime = tz.TZDateTime(
        seoul, now.year, now.month, now.day, hour, minute, second);

    // targetTime이 현재 시간보다 이전이라면 다음 날로 이동
    if (targetDateTime.isBefore(now)) {
      targetDateTime = targetDateTime.add(const Duration(days: 1));
    }

    return targetDateTime;
  }

  late tz.TZDateTime convertedTargetTime = convertToDateTime(targetTime);

  void doAlertAction() async {
    if (_isGameCompleted) return;

    tz.TZDateTime now = tz.TZDateTime.now(seoul);
    print("현재 시간: $now, targetTime: $convertedTargetTime");

    if (now.isBefore(convertedTargetTime)) {
      print("예약된 targetTime: $convertedTargetTime, 현재 시간: $now");

      await _notificationHelper.scheduleMultipleNotifications(
        convertedTargetTime,
        1,
        Duration.zero,
        "It's time to wake up!",
        "기상할 시간입니다!",
        "game_start",
      );

      final durationUntilTarget = convertedTargetTime.difference(now);
      print("타이머 설정: ${durationUntilTarget.inSeconds}초 후 실행");

      Timer(durationUntilTarget, () {
        print("타이머 실행: targetTime에 도달했습니다.");
        if (!_notificationHelper.isGameStartClicked && !_isGameCompleted) {
          _startRepeatingWakeUpAlert();
        }
      });
    } else {
      print("targetTime이 이미 지남: $convertedTargetTime");
      _startRepeatingWakeUpAlert();
    }
  }

  void _startRepeatingWakeUpAlert() async {
    if (_isGameCompleted) {
      print("wake_up_alert 실행 중단: 게임 완료 상태");
      return;
    }

    print("wake_up_alert 반복 알림 시작");

    try {
      const int notificationCount = 4;
      await _notificationHelper.scheduleMultipleNotifications(
        convertedTargetTime, // targetTime 이후 시작
        notificationCount,
        const Duration(seconds: 5),
        "It's time to wake up!",
        "게임에 접속하세요!",
        "wake_up_alert",
      );
      print("wake_up_alert 반복 알림 예약 완료");
    } catch (e) {
      print("wake_up_alert 알림 예약 중 오류 발생: $e");
    }
  }

  void _stopRepeatingNotifications() async {
    print("wake_up_alert 반복 알림 중단");
    _notificationHelper.cancelNotification(); // 모든 알림 취소
  }

  void _navigateToGameScreen() {
    if (!_isGameCompleted) {
      Get.to(() => const GameStart());
      _isGameCompleted = true;
      _stopRepeatingNotifications(); // 게임 시작 시 반복 알림 중단
    }
  }

  void markGameAsCompleted() {
    _isGameCompleted = true;
    _stopRepeatingNotifications(); // 게임 완료 시 반복 알림 중단
  }
}
