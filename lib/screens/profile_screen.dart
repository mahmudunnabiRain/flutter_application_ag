import 'package:flutter/material.dart';
import 'package:flutter_application_ag/auth_controller.dart';
import 'package:flutter_application_ag/screens/login_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.removeAuth();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login: ${authController.login}'),
            Text('Token: ${authController.token}'),
          ],
        ),
      )),
    );
  }
}
