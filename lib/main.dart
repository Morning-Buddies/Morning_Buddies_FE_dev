import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:morning_buddies/screens/game/game_jigsaw_puzzle.dart';
import 'package:morning_buddies/service/time_service.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morning Buddies',
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignIn(),
        '/main': (context) => const HomeBottomNav(),
        '/game_start': (context) => const GameStart(),
        '/game_puzzle': (context) => const GamePage(),
      },
      home: const SignIn(),
    );
  }
}
