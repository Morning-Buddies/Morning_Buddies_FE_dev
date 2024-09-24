import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/groupchat_controller.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:morning_buddies/screens/home/chat/group_chat_list_page.dart';
import 'package:morning_buddies/screens/home/home_group_detail.dart';
import 'package:morning_buddies/screens/home/home_main.dart';
import 'package:morning_buddies/screens/home/home_profile.dart';
import 'package:morning_buddies/screens/home/home_search.dart';
import 'package:morning_buddies/screens/home/home_setting.dart';
import 'package:morning_buddies/screens/home/my_group_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:morning_buddies/screens/subscription_screen.dart';
import 'package:morning_buddies/service/auth_gate.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';
import 'firebase_options.dart';
// import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Morning Buddies',
      initialRoute: '/auth_gate',
      getPages: [
        GetPage(name: '/auth_gate', page: () => const AuthGate()),
        GetPage(name: '/signin', page: () => const SignIn()),
        GetPage(name: '/main', page: () => const HomeBottomNav()),
        GetPage(name: '/home_main', page: () => const HomeMain()),
        GetPage(
            name: '/chat',
            page: () => GroupChatListPage(),
            binding: BindingsBuilder(() {
              Get.lazyPut<GroupChatStatusController>(
                  () => GroupChatStatusController());
            })),
        GetPage(name: '/profile', page: () => const HomeProfile()),
        GetPage(name: '/search', page: () => const HomeSearch()),
        GetPage(name: '/setting', page: () => const HomeSetting()),
        GetPage(
            name: '/home_group_detail', page: () => const HomeGroupDetail()),
        GetPage(name: '/my_group_detail', page: () => const MyGroupDetail()),
        GetPage(
            name: '/subscription_screen',
            page: () => const SubscriptionScreen()),
        GetPage(name: '/game_start', page: () => const GameStart()),
      ],
    );
  }
}
