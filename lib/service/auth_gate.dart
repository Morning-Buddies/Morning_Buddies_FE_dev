import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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
