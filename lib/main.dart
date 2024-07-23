import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:morning_buddies/screens/home/home_main.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        GetPage(name: '/main', page: () => const HomeBottomNav())
      ],
      // routes: {
      //   '/signin': (context) => const SignIn(),
      //   '/main': (context) => const HomeBottomNav(),
      // },
      // home: const SignIn(),
    );
  }
}
