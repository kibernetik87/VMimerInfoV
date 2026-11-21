//(VIV [Notification Storage — 2026-10-12])

import 'package:shared_preferences/shared_preferences.dart';

//(VIV [Notification Storage Class — 2026-10-12])

class NotificationStorage {
  static const String _hashrateThresholdKey = 'notification_hashrate_threshold';
  static const String _hashrateEnabledKey = 'notification_hashrate_enabled';
  static const String _workersChangeEnabledKey =
      'notification_workers_change_enabled';
  static const String _lastWorkersOnlineKey =
      'notification_last_workers_online';
  static const String _hashrateBelowThresholdKey =
      'notification_hashrate_below_threshold';

  static const String _monitoringEnabledKey = 'notification_monitoring_enabled';
  static const String _hashrateRestoredEnabledKey =
      'notification_hashrate_restored_enabled';
  static const String _workerOfflineEnabledKey =
      'notification_worker_offline_enabled';
  static const String _workerOnlineEnabledKey =
      'notification_worker_online_enabled';
  static const String _newPaymentEnabledKey =
      'notification_new_payment_enabled';
  static const String _balanceThresholdEnabledKey =
      'notification_balance_threshold_enabled';
  static const String _balanceThresholdKey = 'notification_balance_threshold';
  static const String _workerOfflineDelayKey =
      'notification_worker_offline_delay';
  static const String _lastHashrateKey = 'notification_last_hashrate';
  static const String _lastBalanceKey = 'notification_last_balance';
  static const String _lastPaymentKey = 'notification_last_payment';
  static const String _offlineWorkerSinceKey =
      'notification_offline_worker_since';

  //(VIV [Wallet Scoped Keys — 2026-10-12])

  String _key(String baseKey, String? walletId) {
    if (walletId == null || walletId.isEmpty) {
      return baseKey;
    }

    return '${baseKey}_wallet_$walletId';
  }

  Future<SharedPreferences> get _preferences async {
    return SharedPreferences.getInstance();
  }

  //) VIV [Wallet Scoped Keys — 2026-10-12]

  //(VIV [Monitoring Enabled — 2026-10-12])

  Future<bool> loadMonitoringEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_monitoringEnabledKey, walletId)) ?? false;
  }

  Future<void> saveMonitoringEnabled(bool value, {String? walletId}) async {
    final preferences = await _preferences;
    final key = _key(_monitoringEnabledKey, walletId);

    await preferences.setBool(key, value);

    if (!value && walletId != null) {
      await resetMonitoringBaseline(walletId: walletId);
    }
  }

  //) VIV [Monitoring Enabled — 2026-10-12]

  //(VIV [Hashrate Threshold — 2026-10-12])

  Future<double> loadHashrateThreshold({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getDouble(_key(_hashrateThresholdKey, walletId)) ?? 0;
  }

  Future<void> saveHashrateThreshold(double value, {String? walletId}) async {
    final preferences = await _preferences;

    await preferences.setDouble(_key(_hashrateThresholdKey, walletId), value);

    await preferences.remove(_key(_hashrateBelowThresholdKey, walletId));
  }

  //) VIV [Hashrate Threshold — 2026-10-12]

  //(VIV [Hashrate Drop Notification — 2026-10-12])

  Future<bool> loadHashrateEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_hashrateEnabledKey, walletId)) ?? false;
  }

  Future<void> saveHashrateEnabled(bool value, {String? walletId}) async {
    final preferences = await _preferences;

    await preferences.setBool(_key(_hashrateEnabledKey, walletId), value);

    if (!value) {
      await preferences.remove(_key(_hashrateBelowThresholdKey, walletId));
    }
  }

  //) VIV [Hashrate Drop Notification — 2026-10-12]

  //(VIV [Hashrate Restored Notification — 2026-10-12])

  Future<bool> loadHashrateRestoredEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_hashrateRestoredEnabledKey, walletId)) ??
        false;
  }

  Future<void> saveHashrateRestoredEnabled(
    bool value, {
    String? walletId,
  }) async {
    final preferences = await _preferences;
    await preferences.setBool(
      _key(_hashrateRestoredEnabledKey, walletId),
      value,
    );
  }

  //) VIV [Hashrate Restored Notification — 2026-10-12]

  //(VIV [Worker Notifications — 2026-10-12])

  Future<bool> loadWorkersChangeEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_workersChangeEnabledKey, walletId)) ??
        false;
  }

  Future<void> saveWorkersChangeEnabled(bool value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setBool(_key(_workersChangeEnabledKey, walletId), value);
  }

  Future<bool> loadWorkerOfflineEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_workerOfflineEnabledKey, walletId)) ??
        false;
  }

  Future<void> saveWorkerOfflineEnabled(bool value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setBool(_key(_workerOfflineEnabledKey, walletId), value);
  }

  Future<bool> loadWorkerOnlineEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_workerOnlineEnabledKey, walletId)) ??
        false;
  }

  Future<void> saveWorkerOnlineEnabled(bool value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setBool(_key(_workerOnlineEnabledKey, walletId), value);
  }

  Future<int> loadWorkerOfflineDelay({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getInt(_key(_workerOfflineDelayKey, walletId)) ?? 5;
  }

  Future<void> saveWorkerOfflineDelay(int minutes, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setInt(
      _key(_workerOfflineDelayKey, walletId),
      minutes < 0 ? 0 : minutes,
    );
  }

  Future<int?> loadLastWorkersOnline({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getInt(_key(_lastWorkersOnlineKey, walletId));
  }

  Future<void> saveLastWorkersOnline(int value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setInt(_key(_lastWorkersOnlineKey, walletId), value);
  }

  Future<void> clearLastWorkersOnline({String? walletId}) async {
    final preferences = await _preferences;
    await preferences.remove(_key(_lastWorkersOnlineKey, walletId));
  }

  //) VIV [Worker Notifications — 2026-10-12]

  //(VIV [Hashrate Threshold State — 2026-10-12])

  Future<bool> loadHashrateBelowThreshold({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_hashrateBelowThresholdKey, walletId)) ??
        false;
  }

  Future<void> saveHashrateBelowThreshold(
    bool value, {
    String? walletId,
  }) async {
    final preferences = await _preferences;
    await preferences.setBool(
      _key(_hashrateBelowThresholdKey, walletId),
      value,
    );
  }

  //) VIV [Hashrate Threshold State — 2026-10-12]

  //(VIV [Payment Notifications — 2026-10-12])

  Future<bool> loadNewPaymentEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_newPaymentEnabledKey, walletId)) ?? false;
  }

  Future<void> saveNewPaymentEnabled(bool value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setBool(_key(_newPaymentEnabledKey, walletId), value);
  }

  //) VIV [Payment Notifications — 2026-10-12]

  //(VIV [Balance Threshold Notifications — 2026-10-12])

  Future<bool> loadBalanceThresholdEnabled({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getBool(_key(_balanceThresholdEnabledKey, walletId)) ??
        false;
  }

  Future<void> saveBalanceThresholdEnabled(
    bool value, {
    String? walletId,
  }) async {
    final preferences = await _preferences;
    await preferences.setBool(
      _key(_balanceThresholdEnabledKey, walletId),
      value,
    );
  }

  Future<double> loadBalanceThreshold({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getDouble(_key(_balanceThresholdKey, walletId)) ?? 0;
  }

  Future<void> saveBalanceThreshold(double value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setDouble(_key(_balanceThresholdKey, walletId), value);
  }

  //) VIV [Balance Threshold Notifications — 2026-10-12]

  //(VIV [Monitoring Baselines — 2026-10-12])

  Future<double?> loadLastHashrate({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getDouble(_key(_lastHashrateKey, walletId));
  }

  Future<void> saveLastHashrate(double value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setDouble(_key(_lastHashrateKey, walletId), value);
  }

  Future<double?> loadLastBalance({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getDouble(_key(_lastBalanceKey, walletId));
  }

  Future<void> saveLastBalance(double value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setDouble(_key(_lastBalanceKey, walletId), value);
  }

  Future<String?> loadLastPayment({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getString(_key(_lastPaymentKey, walletId));
  }

  Future<void> saveLastPayment(String value, {String? walletId}) async {
    final preferences = await _preferences;
    await preferences.setString(_key(_lastPaymentKey, walletId), value);
  }

  Future<int?> loadOfflineWorkerSince({String? walletId}) async {
    final preferences = await _preferences;
    return preferences.getInt(_key(_offlineWorkerSinceKey, walletId));
  }

  Future<void> saveOfflineWorkerSince(
    int timestampMs, {
    String? walletId,
  }) async {
    final preferences = await _preferences;
    await preferences.setInt(
      _key(_offlineWorkerSinceKey, walletId),
      timestampMs,
    );
  }

  Future<void> clearOfflineWorkerSince({String? walletId}) async {
    final preferences = await _preferences;
    await preferences.remove(_key(_offlineWorkerSinceKey, walletId));
  }

  /// Очищає базові значення, щоб повторне ввімкнення
  /// моніторингу починалося з нового успішного знімка.
  Future<void> resetMonitoringBaseline({String? walletId}) async {
    final preferences = await _preferences;

    await preferences.remove(_key(_lastWorkersOnlineKey, walletId));
    await preferences.remove(_key(_hashrateBelowThresholdKey, walletId));
    await preferences.remove(_key(_lastHashrateKey, walletId));
    await preferences.remove(_key(_lastBalanceKey, walletId));
    await preferences.remove(_key(_lastPaymentKey, walletId));
    await preferences.remove(_key(_offlineWorkerSinceKey, walletId));
  }

  //) VIV [Monitoring Baselines — 2026-10-12]

  //(VIV [Remove Wallet Notification Settings — 2026-10-12])

  /// Видаляє всі налаштування й стани сповіщень одного гаманця.
  Future<void> removeWalletSettings(String walletId) async {
    final preferences = await _preferences;

    const keys = [
      _hashrateThresholdKey,
      _hashrateEnabledKey,
      _workersChangeEnabledKey,
      _lastWorkersOnlineKey,
      _hashrateBelowThresholdKey,
      _monitoringEnabledKey,
      _hashrateRestoredEnabledKey,
      _workerOfflineEnabledKey,
      _workerOnlineEnabledKey,
      _newPaymentEnabledKey,
      _balanceThresholdEnabledKey,
      _balanceThresholdKey,
      _workerOfflineDelayKey,
      _lastHashrateKey,
      _lastBalanceKey,
      _lastPaymentKey,
      _offlineWorkerSinceKey,
    ];

    for (final baseKey in keys) {
      await preferences.remove(_key(baseKey, walletId));
    }
  }

  //) VIV [Remove Wallet Notification Settings — 2026-10-12]
}

//) VIV [Notification Storage Class — 2026-10-12]

//) VIV [Notification Storage — 2026-10-12]
