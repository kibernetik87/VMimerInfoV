//(VIV [Widget Refresh Scheduler — 2026-10-08])

import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';

import '../storage/widget_refresh_settings_storage.dart';

import 'dart:convert';

//(VIV [Widget Refresh Scheduler Constants — 2026-10-08])

const String widgetRefreshTaskName = 'vmimerinfov_widget_refresh';

const String widgetRefreshUniqueTaskName = 'vmimerinfov_widget_refresh_task';

const String widgetRefreshAutomaticUniqueTaskName =
    'vmimerinfov_widget_refresh_automatic_task';

const String widgetRefreshWalletsInputKey = 'widget_wallets';

const String widgetRefreshAutomaticInputKey = 'widget_refresh_automatic';

const String widgetRefreshAutomaticIntervalMsInputKey =
    'widget_refresh_automatic_interval_ms';

const String widgetRefreshAutomaticTag = 'vmimerinfov_widget_refresh_automatic';

//) VIV [Widget Refresh Scheduler Constants — 2026-10-08]

//(VIV [Widget Refresh Scheduler Class — 2026-10-08])

class WidgetRefreshScheduler {
  WidgetRefreshScheduler({WidgetRefreshSettingsStorage? settingsStorage})
    : _settingsStorage = settingsStorage ?? WidgetRefreshSettingsStorage();

  static const MethodChannel _widgetChannel = MethodChannel(
    'com.example.vmimerinfov/widget',
  );

  static const String _scheduleAutomaticWidgetRefreshMethod =
      'scheduleAutomaticWidgetRefresh';

  static const String _cancelAutomaticWidgetRefreshMethod =
      'cancelAutomaticWidgetRefresh';

  final WidgetRefreshSettingsStorage _settingsStorage;

  //(VIV [Load Current Refresh Interval — 2026-10-08])

  Future<Duration> loadCurrentRefreshInterval() async {
    return _settingsStorage.loadRefreshInterval();
  }

  //) VIV [Load Current Refresh Interval — 2026-10-08]

  //(VIV [Schedule Widget Refresh From App — 2026-10-08])

  Future<void> scheduleFromApp() async {
    final interval = await _settingsStorage.loadRefreshInterval();

    await _widgetChannel.invokeMethod<void>(
      _scheduleAutomaticWidgetRefreshMethod,
      <String, dynamic>{'intervalMs': interval.inMilliseconds},
    );
  }

  //) VIV [Schedule Widget Refresh From App — 2026-10-08]

  //(VIV [Cancel Automatic Widget Refresh — 2026-10-08])

  Future<void> cancelAutomaticRefresh() async {
    await _widgetChannel.invokeMethod<void>(
      _cancelAutomaticWidgetRefreshMethod,
    );
  }

  //) VIV [Cancel Automatic Widget Refresh — 2026-10-08]

  //(VIV [Schedule Immediate Widget Refresh — 2026-10-08])

  Future<void> scheduleImmediate({
    required Map<int, String> widgetWallets,
  }) async {
    if (widgetWallets.isEmpty) {
      return;
    }

    final encodedWidgetWallets = _encodeWidgetWallets(widgetWallets);

    await Workmanager().registerOneOffTask(
      widgetRefreshUniqueTaskName,
      widgetRefreshTaskName,
      initialDelay: Duration.zero,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      inputData: <String, dynamic>{
        widgetRefreshWalletsInputKey: encodedWidgetWallets,
      },
    );
  }

  //) VIV [Schedule Immediate Widget Refresh — 2026-10-08]

  //(VIV [Encode Widget Wallets — 2026-10-08])

  String _encodeWidgetWallets(Map<int, String> widgetWallets) {
    return jsonEncode(
      widgetWallets.map(
        (appWidgetId, walletId) => MapEntry(appWidgetId.toString(), walletId),
      ),
    );
  }

  //) VIV [Encode Widget Wallets — 2026-10-08]
}

//) VIV [Widget Refresh Scheduler Class — 2026-10-08]

//) VIV [Widget Refresh Scheduler — 2026-10-08]
