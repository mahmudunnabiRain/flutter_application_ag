import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_application_ag/auth_controller.dart';
import 'package:get/get.dart' as getx;

class ApiService {
  late Dio _dio;
  AuthController authController = getx.Get.find<AuthController>();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://peanut.ifxdb.com',
        validateStatus: (status) {
          // return status! < 500;
          return true;
        },
      ),
    );
  }

  Future<void> login({required int login, required String password}) async {
    try {
      Response response = await _dio.post(
        '/api/ClientCabinetBasic/IsAccountCredentialsCorrect',
        data: {
          "login": login,
          "password": password,
        },
      );
      if (response.statusCode == 200 && response.data['result'] == true) {
        String token = response.data['token'];
        // Save the token here
        authController.setAuth(login, token);
        log('Login successful $token');
      } else if (response.statusCode == 401) {
        authController.setAuth(login, '123');
        throw 'Invalid login.';
      } else {
        throw 'Server Error';
      }
    } catch (e) {
      rethrow;
    }
  }
}
