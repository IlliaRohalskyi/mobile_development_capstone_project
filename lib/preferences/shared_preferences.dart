import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setLanguage(String language) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('language', language);
  }

  Future<String?> getLanguage() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('language');
  }

  Future<void> setTheme(bool isDarkTheme) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isDarkTheme', isDarkTheme);
  }

  Future<bool?> getTheme() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('isDarkTheme');
  }
}