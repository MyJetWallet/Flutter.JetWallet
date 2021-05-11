import 'package:shared_preferences/shared_preferences.dart';

//TODO(Vova): It is needed to use secured storage for tokens.
class ConfigStorage {
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
