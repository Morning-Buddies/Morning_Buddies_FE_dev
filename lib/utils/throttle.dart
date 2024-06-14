import 'dart:async';

class Throttle {
  final Duration delay;
  bool waiting = false;
  Timer? _timer;
  Throttle({required this.delay});

  void run(action) {
    // 타이머를 기다리지 않을 때만
    if (!waiting) {
      // action을 실행하고 이벤트를 기다림
      action();
      waiting = true;

      // 지정된 시간이 지나면 waiting을 풀어줌
      _timer = Timer(delay, () {
        waiting = false;
      });
    }
  }
}
