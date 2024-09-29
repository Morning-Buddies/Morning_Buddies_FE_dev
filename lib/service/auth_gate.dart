import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _permissionWithNotification();
  }

  void _permissionWithNotification() async {
    await [Permission.notification].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

          if (snapshot.hasData) {
            return const HomeBottomNav();
          } else {
            return const SignIn();
          }
        },
      ),
    );
  }
}
