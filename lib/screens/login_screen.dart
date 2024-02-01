import 'package:flutter/material.dart';
import 'package:flutter_application_ag/api_service.dart';
import 'package:flutter_application_ag/helpers.dart';
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
      mySnack('All fields required!', context, danger: true);
      return;
    }
    setState(() {
      loginLoading = true;
    });
    try {
      await apiService.login(login: int.parse(_loginEditingController.text), password: _passwordEditingController.text);
      if (mounted) {
        mySnack('Login successful.', context);
      }
    } catch (e) {
      if (mounted) {
        mySnack(e.toString(), context, danger: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          loginLoading = false;
        });
      }
    }
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
