import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  static SharedPreferences? _sharedPreferences;

  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future setIsDarkMode(bool value) async {
    await _sharedPreferences!.setBool('isDarkMode', value);
  }

  static bool getIsDarkMode() {
    return _sharedPreferences!.getBool('isDarkMode') ?? false;
  }
}
