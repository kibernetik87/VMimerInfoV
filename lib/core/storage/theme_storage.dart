//(VIV [Theme Storage — 2026-11-08])

import 'package:shared_preferences/shared_preferences.dart';

//(VIV [Theme Storage Class — 2026-11-08])
class ThemeStorage {
  static const String _themeModeKey = 'theme_mode';

  Future<String?> loadThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_themeModeKey);
  }

  Future<void> saveThemeMode(String themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeModeKey, themeMode);
  }
}
//) VIV [Theme Storage Class — 2026-11-08]

//) VIV [Theme Storage — 2026-11-08]
