//(VIV [Wallet Mining Snapshot Cache — 2026-10-05])

import 'package:shared_preferences/shared_preferences.dart';

import '../models/wallet_mining_snapshot.dart';

//(VIV [Wallet Mining Snapshot Cache Class — 2026-10-05])
class WalletMiningSnapshotCache {
  WalletMiningSnapshotCache();

  static const String _keyPrefix = 'wallet_mining_snapshot_';

  //(VIV [Build Snapshot Key — 2026-10-05])
  String _key(String walletId, String field) {
    return '$_keyPrefix${walletId}_$field';
  }
  //) VIV [Build Snapshot Key — 2026-10-05]

  //(VIV [Save Snapshot — 2026-10-05])
  Future<void> save(WalletMiningSnapshot snapshot) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _key(snapshot.walletId, 'walletId'),
      snapshot.walletId,
    );

    await preferences.setString(
      _key(snapshot.walletId, 'walletAddress'),
      snapshot.walletAddress,
    );

    await preferences.setDouble(
      _key(snapshot.walletId, 'hashRate'),
      snapshot.hashRate,
    );

    await preferences.setDouble(
      _key(snapshot.walletId, 'hashRate2'),
      snapshot.hashRate2,
    );

    await preferences.setInt(
      _key(snapshot.walletId, 'workersOnline'),
      snapshot.workersOnline,
    );

    await preferences.setInt(
      _key(snapshot.walletId, 'workersTotal'),
      snapshot.workersTotal,
    );

    await preferences.setDouble(
      _key(snapshot.walletId, 'amountPaid'),
      snapshot.amountPaid,
    );

    await preferences.setDouble(
      _key(snapshot.walletId, 'amountDue'),
      snapshot.amountDue,
    );

    await preferences.setInt(
      _key(snapshot.walletId, 'updatedAt'),
      snapshot.updatedAt.millisecondsSinceEpoch,
    );
  }
  //) VIV [Save Snapshot — 2026-10-05]

  //(VIV [Load Snapshot — 2026-10-05])
  Future<WalletMiningSnapshot?> load(String walletId) async {
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

    return WalletMiningSnapshot(
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
  //) VIV [Load Snapshot — 2026-10-05]

  //(VIV [Remove Snapshot — 2026-10-05])
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
  //) VIV [Remove Snapshot — 2026-10-05]
}
//) VIV [Wallet Mining Snapshot Cache Class — 2026-10-05]

//) VIV [Wallet Mining Snapshot Cache — 2026-10-05]
