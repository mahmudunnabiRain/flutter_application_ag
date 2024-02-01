import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxInt? login;
  RxString? token;

  Future<void> loadAuthFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedLogin = prefs.getInt('login');
    String? storedToken = prefs.getString('token');

    if (storedLogin != null && storedToken != null) {
      login = storedLogin.obs;
      token = storedToken.obs;
    }
  }

  bool isAuthenticated() {
    return login != null && token != null;
  }

  Future<void> setAuth(int newLogin, String newToken) async {
    login = newLogin.obs;
    token = newToken.obs;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login', newLogin);
    await prefs.setString('token', newToken);
  }

  Future<void> removeAuth() async {
    login = null;
    token = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('login');
    await prefs.remove('token');
  }
}
