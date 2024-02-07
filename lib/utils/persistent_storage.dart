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

  static Future setIsNotificationOn(bool value) async {
    await _sharedPreferences!.setBool('isNotificationOn', value);
  }

  static bool getIsNotificationOn() {
    return _sharedPreferences!.getBool('isNotificationOn') ?? false;
  }

  static Future setIsUsageStatisticsOn(bool value) async {
    await _sharedPreferences!.setBool('isUsageStatisticsOn', value);
  }

  static bool getIsUsageStatisticsOn() {
    return _sharedPreferences!.getBool('isUsageStatisticsOn') ?? false;
  }
}
