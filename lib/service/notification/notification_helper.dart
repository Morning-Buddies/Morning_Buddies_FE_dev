import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/auth/auth_gate.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    // Android 설정
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings("splash");

    // iOS 설정
    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);

    // 초기화
    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == "game_start") {
          Get.offAll(const GameStart()); // 알림 클릭 시 GameStart 화면으로 이동
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse response) {
        if (response.payload == "game_start") {
          Get.offAll(const GameStart());
        }
      },
    );

    // Android 알림 채널 생성
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "1", // channelId
      "Test Notifications", // channelName
      description:
          "This channel is for test notifications", // channelDescription
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermissions() async {
    // 알림 권한 요청
    await [Permission.notification].request();
  }

  Future<void> scheduleNotification(DateTime scheduledTime) async {
    await _local.zonedSchedule(
      0, // 알림 ID
      "It's time to play!", // 알림 제목
      "Tap to start the game", // 알림 내용
      tz.TZDateTime.from(scheduledTime, tz.local), // 알림 예약 시간
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
      payload: "game_start",
    );
  }

  Future<void> showNotification(String title, String body) async {
    const NotificationDetails details = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        "1", // 동일한 channelId 사용
        "Test Notifications",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _local.show(
      1, // 알림 ID
      title,
      body,
      details,
      payload: "game_start", // 알림 클릭 시 전달할 payload
    );
  }
}
