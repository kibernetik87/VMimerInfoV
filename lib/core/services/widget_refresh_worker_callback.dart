//(VIV [Widget Refresh Worker Callback — 2026-11-02])

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:widget_refresh_bridge/widget_refresh_bridge.dart';

import '../app_dependencies.dart';
import 'mining_notification_monitor.dart';
import 'notification_service.dart';
import 'widget_refresh_scheduler.dart';
import 'widget_refresh_worker.dart';

//(VIV [Widget Refresh Debug Logger — 2026-11-21])
void _debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
//) VIV [Widget Refresh Debug Logger — 2026-11-21]
//(VIV [Widget Refresh Task Handler — 2026-11-02])

@pragma('vm:entry-point')
Future<bool> runWidgetRefreshTask(Map<String, dynamic>? inputData) async {
  final dependencies = AppDependencies();
  final bridge = WidgetRefreshBridge();
  final isAutomatic = inputData?[widgetRefreshAutomaticInputKey] == true;
  final widgetWallets = _loadWidgetWallets(inputData);

  // Any wallet refresh error means that WorkManager should retry.
  var hasRefreshFailure = false;

  try {
    if (widgetWallets.isEmpty) {
      _debugLog(
        '[VMimerInfoV Widget Refresh] '
        'no widget wallets to refresh',
      );
      return true;
    }

    _debugLog(
      '[VMimerInfoV Widget Refresh] '
      '${isAutomatic ? 'automatic' : 'manual'} cycle started',
    );
    _debugLog('[VMimerInfoV Widget Refresh] wallets: $widgetWallets');

    //(VIV [Initialize Background Notifications — 2026-11-02])
    final notificationService = NotificationService();
    await notificationService.initialize();

    final notificationMonitor = MiningNotificationMonitor(
      storage: dependencies.notificationStorage,
      notificationService: notificationService,
      eventStorage: dependencies.notificationEventStorage,
    );
    //) VIV [Initialize Background Notifications — 2026-11-02]

    //(VIV [Load Wallets For Notification Names — 2026-11-02])
    final wallets = await dependencies.walletStorage.loadWallets();
    //) VIV [Load Wallets For Notification Names — 2026-11-02]

    final walletIds = widgetWallets.values.toSet();

    for (final walletId in walletIds) {
      _debugLog('[VMimerInfoV Widget Refresh] refresh wallet: $walletId');

      try {
        final snapshot = await WidgetRefreshWorker(dependencies: dependencies)
            .refreshWallet(walletId);

        if (snapshot == null) {
          _debugLog(
            '[VMimerInfoV Widget Refresh] '
            'wallet not found: $walletId',
          );
          continue;
        }

        _debugLog('[VMimerInfoV Widget Refresh] wallet refreshed: $walletId');

        //(VIV [Check Wallet Notifications — 2026-11-02])
        try {
          final walletIndex = wallets.indexWhere(
            (wallet) => wallet.id == walletId,
          );

          final walletName = walletIndex == -1
              ? null
              : wallets[walletIndex].name;

          await notificationMonitor.check(
            hashRate: snapshot.hashRate,
            workersOnline: snapshot.workersOnline,
            walletId: snapshot.walletId,
            walletName: walletName,
          );

          _debugLog(
            '[VMimerInfoV Widget Refresh] '
            'notifications checked: $walletId',
          );
        } catch (error, stackTrace) {
          _debugLog(
            '[VMimerInfoV Widget Refresh] '
            'notification ERROR for $walletId: $error',
          );
          _debugLog(
            '[VMimerInfoV Widget Refresh] '
            'notification STACK: $stackTrace',
          );
        }
        //) VIV [Check Wallet Notifications — 2026-11-02]
      } catch (error, stackTrace) {
        hasRefreshFailure = true;

        _debugLog(
          '[VMimerInfoV Widget Refresh] '
          'wallet ERROR for $walletId: $error',
        );
        _debugLog(
          '[VMimerInfoV Widget Refresh] '
          'wallet STACK: $stackTrace',
        );
      }
    }

    _debugLog('[VMimerInfoV Widget Refresh] updating widgets');

    await bridge.updateAllWidgets();

    _debugLog('[VMimerInfoV Widget Refresh] widgets updated');

    if (hasRefreshFailure) {
      _debugLog(
        '[VMimerInfoV Widget Refresh] '
        'one or more wallets failed; requesting retry',
      );
      return false;
    }

    _debugLog(
      '[VMimerInfoV Widget Refresh] '
      'all wallet refreshes completed successfully',
    );

    return true;
  } catch (error, stackTrace) {
    _debugLog('[VMimerInfoV Widget Refresh] ERROR: $error');
    _debugLog('[VMimerInfoV Widget Refresh] STACK: $stackTrace');

    //(VIV [Update Widgets After Refresh Error — 2026-11-02])
    try {
      await bridge.updateAllWidgets();
    } catch (updateError) {
      _debugLog(
        '[VMimerInfoV Widget Refresh] '
        'widget update ERROR: $updateError',
      );
    }
    //) VIV [Update Widgets After Refresh Error — 2026-11-02]

    return false;
  } finally {
    dependencies.dispose();
  }
}

//) VIV [Widget Refresh Task Handler — 2026-11-02]

//(VIV [Load Widget Wallets From Input Data — 2026-11-02])

Map<int, String> _loadWidgetWallets(Map<String, dynamic>? inputData) {
  final encodedWidgetWallets = inputData?[widgetRefreshWalletsInputKey]
      ?.toString();

  if (encodedWidgetWallets == null || encodedWidgetWallets.isEmpty) {
    return <int, String>{};
  }

  try {
    final decoded = jsonDecode(encodedWidgetWallets);

    if (decoded is! Map) {
      return <int, String>{};
    }

    final widgetWallets = <int, String>{};

    for (final entry in decoded.entries) {
      final appWidgetId = int.tryParse(entry.key.toString());
      final walletId = entry.value?.toString();

      if (appWidgetId == null || walletId == null || walletId.isEmpty) {
        continue;
      }

      widgetWallets[appWidgetId] = walletId;
    }

    return widgetWallets;
  } catch (_) {
    return <int, String>{};
  }
}

//) VIV [Load Widget Wallets From Input Data — 2026-11-02]

//) VIV [Widget Refresh Worker Callback — 2026-11-02]
