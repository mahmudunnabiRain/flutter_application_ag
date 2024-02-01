import 'package:flutter/material.dart';
import 'package:flutter_application_ag/api_service.dart';
import 'package:flutter_application_ag/auth_controller.dart';
import 'package:flutter_application_ag/screens/login_screen.dart';
import 'package:flutter_application_ag/screens/profile_screen.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthController authController = AuthController();
  await authController.loadAuthFromPrefs();
  Get.put(authController);
  Get.put(ApiService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peanut',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          toolbarHeight: 40,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          elevation: 1,
        ),
      ),
      home: authController.isAuthenticated() ? const ProfileScreen() : const LoginScreen(),
    );
  }
}
