//(VIV [Mining Notification Monitor — 2026-11-08])

import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../models/notification_event.dart';
import '../storage/locale_storage.dart';
import '../storage/notification_event_storage.dart';
import '../storage/notification_storage.dart';
import 'notification_service.dart';

//(VIV [Mining Notification Monitor Class — 2026-11-08])

class MiningNotificationMonitor {
  //(VIV [Mining Notification Monitor Constructor — 2026-11-08])

  MiningNotificationMonitor({
    required this.storage,
    required this.notificationService,
    required this.eventStorage,
    LocaleStorage? localeStorage,
  }) : localeStorage = localeStorage ?? LocaleStorage();

  final NotificationStorage storage;
  final NotificationService notificationService;
  final NotificationEventStorage eventStorage;
  final LocaleStorage localeStorage;

  //) VIV [Mining Notification Monitor Constructor — 2026-11-08]

  //(VIV [Load Notification Localizations — 2026-11-08])

  Future<AppLocalizations> _loadLocalizations() async {
    final languageCode = await localeStorage.loadLanguageCode();

    final locale = Locale(languageCode == 'en' ? 'en' : 'uk');

    return AppLocalizations.delegate.load(locale);
  }

  //) VIV [Load Notification Localizations — 2026-11-08]

  //(VIV [Check Mining Notifications — 2026-11-08])

  Future<void> check({
    required double hashRate,
    required int workersOnline,
    String? walletId,
    String? walletName,
  }) async {
    if (walletId != null &&
        !await storage.loadMonitoringEnabled(walletId: walletId)) {
      return;
    }

    await _checkHashrate(
      hashRate: hashRate,
      walletId: walletId,
      walletName: walletName,
    );

    await _checkWorkers(
      workersOnline: workersOnline,
      walletId: walletId,
      walletName: walletName,
    );
  }

  //) VIV [Check Mining Notifications — 2026-11-08]

  //(VIV [Check Hashrate Notifications — 2026-11-08])

  Future<void> _checkHashrate({
    required double hashRate,
    String? walletId,
    String? walletName,
  }) async {
    if (!await storage.loadHashrateEnabled(walletId: walletId)) {
      return;
    }

    final threshold = await storage.loadHashrateThreshold(walletId: walletId);

    if (threshold <= 0) {
      return;
    }

    final wasBelowThreshold = await storage.loadHashrateBelowThreshold(
      walletId: walletId,
    );

    final isBelowThreshold = hashRate < threshold;

    if (isBelowThreshold && !wasBelowThreshold) {
      await storage.saveHashrateBelowThreshold(true, walletId: walletId);

      final localizations = await _loadLocalizations();

      await _notifyAndLog(
        walletId: walletId,
        walletName: walletName,
        type: 'hashrate_below',
        title: localizations.notificationHashrateBelowTitle,
        message: localizations.notificationHashrateBelowMessage(
          _walletPrefix(walletName),
          _formatHashrate(hashRate),
          _formatHashrate(threshold),
        ),
        notificationId: _notificationId(walletId, 1001),
      );

      return;
    }

    if (!isBelowThreshold && wasBelowThreshold) {
      await storage.saveHashrateBelowThreshold(false, walletId: walletId);

      if (walletId == null ||
          await storage.loadHashrateRestoredEnabled(walletId: walletId)) {
        final localizations = await _loadLocalizations();

        await _notifyAndLog(
          walletId: walletId,
          walletName: walletName,
          type: 'hashrate_restored',
          title: localizations.notificationHashrateRestoredTitle,
          message: localizations.notificationHashrateRestoredMessage(
            _walletPrefix(walletName),
            _formatHashrate(hashRate),
          ),
          notificationId: _notificationId(walletId, 1002),
        );
      }
    }
  }

  //) VIV [Check Hashrate Notifications — 2026-11-08]

  //(VIV [Check Workers Notifications — 2026-11-08])

  Future<void> _checkWorkers({
    required int workersOnline,
    String? walletId,
    String? walletName,
  }) async {
    if (!await storage.loadWorkersChangeEnabled(walletId: walletId)) {
      return;
    }

    final previousWorkers = await storage.loadLastWorkersOnline(
      walletId: walletId,
    );

    if (previousWorkers == null) {
      await storage.saveLastWorkersOnline(workersOnline, walletId: walletId);

      return;
    }

    if (previousWorkers != workersOnline) {
      await storage.saveLastWorkersOnline(workersOnline, walletId: walletId);

      final localizations = await _loadLocalizations();

      await _notifyAndLog(
        walletId: walletId,
        walletName: walletName,
        type: 'workers_changed',
        title: localizations.notificationWorkersChangedTitle,
        message: localizations.notificationWorkersChangedMessage(
          _walletPrefix(walletName),
          previousWorkers,
          workersOnline,
        ),
        notificationId: _notificationId(walletId, 1003),
      );
    }
  }

  //) VIV [Check Workers Notifications — 2026-11-08]

  //(VIV [Notify And Log — 2026-11-08])

  Future<void> _notifyAndLog({
    required String type,
    required String title,
    required String message,
    required int notificationId,
    String? walletId,
    String? walletName,
  }) async {
    await notificationService.show(
      id: notificationId,
      title: title,
      body: message,
    );

    await eventStorage.addEvent(
      NotificationEvent(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        timestamp: DateTime.now(),
        type: type,
        title: title,
        message: message,
        walletId: walletId,
      ),
    );
  }

  //) VIV [Notify And Log — 2026-11-08]

  //(VIV [Wallet Notification Prefix — 2026-11-08])

  String _walletPrefix(String? walletName) {
    if (walletName == null || walletName.trim().isEmpty) {
      return '';
    }

    return '[$walletName] ';
  }

  //) VIV [Wallet Notification Prefix — 2026-11-08]

  //(VIV [Wallet-Specific Notification ID — 2026-11-08])

  int _notificationId(String? walletId, int baseId) {
    if (walletId == null || walletId.isEmpty) {
      return baseId;
    }

    return 10000 + (walletId.hashCode.abs() % 1000000) * 10 + (baseId % 10);
  }

  //) VIV [Wallet-Specific Notification ID — 2026-11-08]

  //(VIV [Format Hashrate — 2026-11-08])

  String _formatHashrate(double value) {
    if (value >= 1000000000000) {
      return '${_formatValue(value / 1000000000000)} TH/s';
    }

    if (value >= 1000000000) {
      return '${_formatValue(value / 1000000000)} GH/s';
    }

    if (value >= 1000000) {
      return '${_formatValue(value / 1000000)} MH/s';
    }

    if (value >= 1000) {
      return '${_formatValue(value / 1000)} kH/s';
    }

    return '${_formatValue(value)} H/s';
  }

  //) VIV [Format Hashrate — 2026-11-08]

  //(VIV [Format Numeric Value — 2026-11-08])

  String _formatValue(double value) {
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  //) VIV [Format Numeric Value — 2026-11-08]
}

//) VIV [Mining Notification Monitor Class — 2026-11-08]

//) VIV [Mining Notification Monitor — 2026-11-08]
