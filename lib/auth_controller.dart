import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxInt? _login;
  RxString? _token;

  // Getters
  int? get login => _login?.value;
  String? get token => _token?.value;

  // Computed property for isAuthenticated
  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;
  RxBool get isAuthenticatedObs => _isAuthenticated;

  Future<void> loadAuthFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedLogin = prefs.getInt('login');
    String? storedToken = prefs.getString('token');

    if (storedLogin != null && storedToken != null) {
      _login = storedLogin.obs;
      _token = storedToken.obs;
      _isAuthenticated.value = true;
    }
  }

  Future<void> setAuth(int newLogin, String newToken) async {
    _login = newLogin.obs;
    _token = newToken.obs;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login', newLogin);
    await prefs.setString('token', newToken);

    _isAuthenticated.value = true;
  }

  Future<void> removeAuth() async {
    _login = null;
    _token = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('login');
    await prefs.remove('token');

    _isAuthenticated.value = false;
  }
}
