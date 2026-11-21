//(VIV [Widget Refresh Cache — 2026-10-05])

import 'package:shared_preferences/shared_preferences.dart';

import '../models/widget_refresh_data.dart';

//(VIV [Widget Refresh Cache Class — 2026-10-05])

class WidgetRefreshCache {
  WidgetRefreshCache();

  static const String _keyPrefix = 'widget_refresh_';

  //(VIV [Build Wallet Key — 2026-10-05])

  String _key(String walletId, String field) {
    return '$_keyPrefix${walletId}_$field';
  }

  //) VIV [Build Wallet Key — 2026-10-05]

  //(VIV [Save Wallet Refresh Data — 2026-10-05])

  Future<void> save(WidgetRefreshData data) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_key(data.walletId, 'walletId'), data.walletId);

    await preferences.setString(
      _key(data.walletId, 'walletAddress'),
      data.walletAddress,
    );

    await preferences.setDouble(_key(data.walletId, 'hashRate'), data.hashRate);

    await preferences.setDouble(
      _key(data.walletId, 'hashRate2'),
      data.hashRate2,
    );

    await preferences.setInt(
      _key(data.walletId, 'workersOnline'),
      data.workersOnline,
    );

    await preferences.setInt(
      _key(data.walletId, 'workersTotal'),
      data.workersTotal,
    );

    await preferences.setDouble(
      _key(data.walletId, 'amountPaid'),
      data.amountPaid,
    );

    await preferences.setDouble(
      _key(data.walletId, 'amountDue'),
      data.amountDue,
    );

    await preferences.setInt(
      _key(data.walletId, 'updatedAt'),
      data.updatedAt.millisecondsSinceEpoch,
    );
  }

  //) VIV [Save Wallet Refresh Data — 2026-10-05]

  //(VIV [Load Wallet Refresh Data — 2026-10-05])

  Future<WidgetRefreshData?> load(String walletId) async {
    final preferences = await SharedPreferences.getInstance();

    final storedWalletId = preferences.getString(_key(walletId, 'walletId'));

    final walletAddress = preferences.getString(
      _key(walletId, 'walletAddress'),
    );

    final hashRate = preferences.getDouble(_key(walletId, 'hashRate'));

    final hashRate2 = preferences.getDouble(_key(walletId, 'hashRate2'));

    final workersOnline = preferences.getInt(_key(walletId, 'workersOnline'));

    final workersTotal = preferences.getInt(_key(walletId, 'workersTotal'));

    final amountPaid = preferences.getDouble(_key(walletId, 'amountPaid'));

    final amountDue = preferences.getDouble(_key(walletId, 'amountDue'));

    final updatedAtMs = preferences.getInt(_key(walletId, 'updatedAt'));

    if (storedWalletId == null ||
        walletAddress == null ||
        hashRate == null ||
        hashRate2 == null ||
        workersOnline == null ||
        workersTotal == null ||
        amountPaid == null ||
        amountDue == null ||
        updatedAtMs == null) {
      return null;
    }

    return WidgetRefreshData(
      walletId: storedWalletId,
      walletAddress: walletAddress,
      hashRate: hashRate,
      hashRate2: hashRate2,
      workersOnline: workersOnline,
      workersTotal: workersTotal,
      amountPaid: amountPaid,
      amountDue: amountDue,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
    );
  }

  //) VIV [Load Wallet Refresh Data — 2026-10-05]

  //(VIV [Remove Wallet Refresh Data — 2026-10-05])

  Future<void> remove(String walletId) async {
    final preferences = await SharedPreferences.getInstance();

    final fields = <String>[
      'walletId',
      'walletAddress',
      'hashRate',
      'hashRate2',
      'workersOnline',
      'workersTotal',
      'amountPaid',
      'amountDue',
      'updatedAt',
    ];

    for (final field in fields) {
      await preferences.remove(_key(walletId, field));
    }
  }

  //) VIV [Remove Wallet Refresh Data — 2026-10-05]
}

//) VIV [Widget Refresh Cache Class — 2026-10-05]

//) VIV [Widget Refresh Cache — 2026-10-05]
