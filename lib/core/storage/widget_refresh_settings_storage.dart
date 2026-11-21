//(VIV [Widget Refresh Settings Storage — 2026-10-05])

import 'package:shared_preferences/shared_preferences.dart';

//(VIV [Widget Refresh Settings Storage Class — 2026-10-05])

class WidgetRefreshSettingsStorage {
  WidgetRefreshSettingsStorage();

  static const String _refreshIntervalSecondsKey =
      'widget_refresh_interval_seconds';

  static const int minimumIntervalSeconds = 60;

  static const int maximumIntervalSeconds = 24 * 60 * 60;

  //(VIV [Default Widget Refresh Interval — 2026-10-05])

  static const int defaultIntervalSeconds = 33 * 60;

  //) VIV [Default Widget Refresh Interval — 2026-10-05]

  //(VIV [Load Refresh Interval — 2026-10-05])

  Future<Duration> loadRefreshInterval() async {
    final preferences = await SharedPreferences.getInstance();

    final storedSeconds = preferences.getInt(_refreshIntervalSecondsKey);

    final seconds = storedSeconds ?? defaultIntervalSeconds;

    final normalizedSeconds = _normalizeSeconds(seconds);

    return Duration(seconds: normalizedSeconds);
  }

  //) VIV [Load Refresh Interval — 2026-10-05]

  //(VIV [Save Refresh Interval — 2026-10-05])

  Future<void> saveRefreshInterval(Duration interval) async {
    final seconds = interval.inSeconds;

    final normalizedSeconds = _normalizeSeconds(seconds);

    final preferences = await SharedPreferences.getInstance();

    await preferences.setInt(_refreshIntervalSecondsKey, normalizedSeconds);
  }

  //) VIV [Save Refresh Interval — 2026-10-05]

  //(VIV [Normalize Refresh Interval — 2026-10-05])

  int _normalizeSeconds(int seconds) {
    if (seconds < minimumIntervalSeconds) {
      return minimumIntervalSeconds;
    }

    if (seconds > maximumIntervalSeconds) {
      return maximumIntervalSeconds;
    }

    return seconds;
  }

  //) VIV [Normalize Refresh Interval — 2026-10-05]
}

//) VIV [Widget Refresh Settings Storage Class — 2026-10-05]

//) VIV [Widget Refresh Settings Storage — 2026-10-05]
