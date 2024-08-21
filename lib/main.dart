import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/route_manager.dart';
=======
import 'package:get/get.dart';
import 'package:morning_buddies/models/group_controller.dart';
import 'package:morning_buddies/screens/home/home_chat.dart';
import 'package:morning_buddies/screens/home/home_group_detail.dart';
>>>>>>> 246c062 (FEAT: My Groups GetX적용 및 UI 추가)
import 'package:morning_buddies/screens/home/home_main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:morning_buddies/screens/subscription_screen.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
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
      initialRoute: '/signin',
      getPages: [
        GetPage(name: '/signin', page: () => const SignIn()),
<<<<<<< HEAD
        GetPage(name: '/main', page: () => const HomeBottomNav())
      ],
      // routes: {
      //   '/signin': (context) => const SignIn(),
      //   '/main': (context) => const HomeBottomNav(),
      // },
      // home: const SignIn(),
=======
        GetPage(name: '/main', page: () => const HomeBottomNav()),
        GetPage(name: '/home_main', page: () => const HomeMain()),
        GetPage(name: '/chat', page: () => const HomeChat()),
        GetPage(name: '/profile', page: () => const HomeProfile()),
        GetPage(name: '/search', page: () => const HomeSearch()),
        GetPage(name: '/setting', page: () => const HomeSetting()),
        GetPage(
            name: '/home_group_detail', page: () => const HomeGroupDetail()),
        GetPage(name: '/my_group_detail', page: () => const MyGroupDetail()),
        GetPage(
            name: '/subscription_screen',
            page: () => const SubscriptionScreen()),
      ],
>>>>>>> 246c062 (FEAT: My Groups GetX적용 및 UI 추가)
    );
  }
}
