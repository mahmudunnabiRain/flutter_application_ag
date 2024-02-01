import 'package:flutter/material.dart';
import 'package:flutter_application_ag/api_service.dart';
import 'package:flutter_application_ag/screens/profile_screen.dart';
import 'package:flutter_application_ag/widgets/my_button.dart';
import 'package:flutter_application_ag/widgets/outlined_text_field.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final ApiService apiService = Get.find<ApiService>();
  bool loginLoading = false;

  Future<void> loginPressed() async {
    if (_loginEditingController.text == '' || _passwordEditingController.text == '') {
      showErrorSnack('All fields required!');
      return;
    }
    setState(() {
      loginLoading = true;
    });
    try {
      await apiService.login(login: int.parse(_loginEditingController.text), password: _passwordEditingController.text);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      }
    } catch (e) {
      showErrorSnack(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          loginLoading = false;
        });
      }
    }
  }

  showErrorSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Enter you login code and password to login.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                OutlinedTextField(
                  label: 'Login',
                  controller: _loginEditingController,
                  keyboardType: TextInputType.number,
                ),
                OutlinedTextField(label: 'Password', controller: _passwordEditingController, obscureText: true),
                MyButton(text: 'Login', onPress: loginPressed, loading: loginLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
