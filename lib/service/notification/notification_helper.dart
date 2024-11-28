import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/auth/auth_gate.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// 엔트리 포인트 오류 방지 차원
@pragma('vm:entry-point')
void backgroundNotificationHandler(NotificationResponse response) {
  print('Received payload: ${response.payload}'); // Debug print
  if (response.payload == "game_start") {
    Get.to(() => const GameStart()); // 또는 다른 페이지로 네비게이트
  } else if (response.payload == "wake_up_alert") {
    Get.to(() => const GameStart()); // 또는 다른 페이지로 네비게이트
  }
}

class NotificationHelper {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  bool isGameStartClicked = false; // 알림 클릭 여부 플래그

  final seoul = tz.getLocation('Asia/Seoul');

  Future<void> requestPermissions() async {
    // 알림 권한 요청
    await [Permission.notification].request();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings("splash");

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    // 알림 초기화
    await _local.initialize(settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('알림 클릭: ${response.payload}');
      if (response.payload == "game_start") {
        isGameStartClicked = true; // 클릭 플래그 설정
        Get.to(() => const GameStart());
      } else if (response.payload == "wake_up_alert") {
        Get.to(() => const GameStart()); // 또는 다른 페이지로 네비게이트
      }
    },
        // 백그라운드 노티 Response 발생시
        onDidReceiveBackgroundNotificationResponse:
            backgroundNotificationHandler);

    // Android 알림 채널 생성
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "1",
      "Test Notifications",
      description: "This channel is for test notifications",
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> scheduleMultipleNotifications(
    tz.TZDateTime startTime, // 알림 시작 시간
    int count, // 알림 반복 횟수
    Duration interval, // 알림 간격
    String title, // 알림 제목
    String body, // 알림 본문
    String payload, // 알림 페이로드
  ) async {
    for (int i = 0; i < count; i++) {
      final tz.TZDateTime scheduledTime = startTime.add(interval * i);

      // 유효성 검사: 과거 시간이라면 예약 건너뛰기
      if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        print("알림 예약 건너뜀: $scheduledTime는 이미 지났습니다.");
        continue;
      }

      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000) + i;

      await _local.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "1",
            "Test Notifications",
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      print("알림 예약 완료: $scheduledTime");
    }
  }

  Future<void> cancelNotification() async {
    await _local.cancelAll();
  }
}
