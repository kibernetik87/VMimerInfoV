//(VIV [Locale Storage — 2026-10-04])

import 'package:shared_preferences/shared_preferences.dart';

//(VIV [Locale Storage Class — 2026-10-04])
class LocaleStorage {
  static const String _languageCodeKey = 'language_code';

  Future<String?> loadLanguageCode() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_languageCodeKey);
  }

  Future<void> saveLanguageCode(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_languageCodeKey, languageCode);
  }
}
