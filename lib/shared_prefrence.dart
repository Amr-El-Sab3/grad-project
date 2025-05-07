import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;
  late SharedPreferences _prefs;

  SharedPrefs._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get token => _prefs.getString('user_token');

  Future<void> saveToken(String token) async {
    await _prefs.setString('user_token', token);
  }

  Future<void> clearToken() async {
    await _prefs.remove('user_token');
  }
}
