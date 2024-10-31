import 'dart:async';
import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/time_utils.dart';

class TimeService {
  Timer? _timer;

  void alarmAction(DateTime targetTime, VoidCallback onTimeReached) {
    _timer?.cancel();

    Duration durationUntilTarget = TimeUtils.timeUntil(targetTime);

    if (durationUntilTarget == Duration.zero) {
      // 설정시간과 현재시간 일치시
      onTimeReached();
    } else {
      _timer = Timer(durationUntilTarget, onTimeReached);
    }
  }

  // 새로운 메서드: 목표 시간이 현재와 동일한지 확인
  bool isTargetTime(DateTime targetTime) {
    DateTime now = DateTime.now();
    return now.year == targetTime.year &&
        now.month == targetTime.month &&
        now.day == targetTime.day &&
        now.hour == targetTime.hour &&
        now.minute == targetTime.minute &&
        now.second == targetTime.second;
  }

  void dispose() {
    _timer?.cancel();
  }
}
