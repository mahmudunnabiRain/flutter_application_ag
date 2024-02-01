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
        throw 'Invalid login.';
      } else {
        throw 'Server Error';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAccountInformation() async {
    try {
      Response response = await _dio.post(
        '/api/ClientCabinetBasic/GetAccountInformation',
        data: {
          "login": authController.login,
          "token": authController.token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> accountInformation = response.data;
        // retrieve phone number and update the account information with phone number
        String phone = await getLastFourNumbersPhone();
        accountInformation['phone'] = phone;
        return accountInformation;
      } else if (response.statusCode == 401) {
        throw 'Unauthorized.';
      } else if (response.statusCode == 500 && response.data == 'Access denied') {
        authController.removeAuth();
        throw 'Token Expired.';
      } else {
        throw 'Server Error';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getLastFourNumbersPhone() async {
    try {
      Response response = await _dio.post(
        '/api/ClientCabinetBasic/GetLastFourNumbersPhone',
        data: {
          "login": authController.login,
          "token": authController.token,
        },
      );
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        throw 'Unauthorized.';
      } else if (response.statusCode == 500 && response.data == 'Access denied') {
        authController.removeAuth();
        throw 'Token Expired.';
      } else {
        throw 'Server Error';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getOpenTrades() async {
    try {
      Response response = await _dio.post(
        '/api/ClientCabinetBasic/GetOpenTrades',
        data: {
          "login": authController.login,
          "token": authController.token,
        },
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.statusCode == 401) {
        throw 'Unauthorized.';
      } else if (response.statusCode == 500 && response.data == 'Access denied') {
        authController.removeAuth();
        throw 'Token Expired.';
      } else {
        throw 'Server Error';
      }
    } catch (e) {
      rethrow;
    }
  }
}
