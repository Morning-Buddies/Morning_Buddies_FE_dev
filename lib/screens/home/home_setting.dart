import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/screens/home/password_reset.dart';
import 'package:morning_buddies/auth/firebase_auth_service.dart';

class HomeSetting extends StatefulWidget {
  const HomeSetting({super.key});

  @override
  State<HomeSetting> createState() => _HomeSettingState();
}

void logout() {
  final auth = AuthService();
  auth.signOut();
  Get.toNamed('/auth_gate');
  // 🚨 추후 DeleteToken
}

class _HomeSettingState extends State<HomeSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: [
            const Divider(),
            const ListTile(
              title: Text(
                "Privacy",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Color(0xFFEFEFF0)),
              child: ListTile(
                title: const Text('Password Reset'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // GET 전환
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PasswordReset()),
                  );
                },
              ),
            ),
            const SizedBox(height: 2),
            Container(
              decoration: const BoxDecoration(color: Color(0xFFEFEFF0)),
              child: ListTile(
                title: const Text('Sign Out'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  logout();
                },
              ),
            ),
            const SizedBox(height: 2),
            Container(
              decoration: const BoxDecoration(color: Color(0xFFEFEFF0)),
              child: ListTile(
                title: const Text('Resign'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ),
            const ListTile(
              title: Text(
                "Service",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Color(0xFFEFEFF0)),
              child: ListTile(
                title: const Text('Terms & Policies'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 2),
            Container(
              decoration: const BoxDecoration(color: Color(0xFFEFEFF0)),
              child: ListTile(
                title: const Text('Help & Contact'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ),
          ],
        ));
  }
}
