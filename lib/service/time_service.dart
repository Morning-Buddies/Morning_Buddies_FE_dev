// 시간 기반 동작( 특정 시간에 도달시 콜백 실행)
// Timer 유지 관리
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

  void dispose() {
    _timer?.cancel();
  }
}
