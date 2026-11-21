//(VIV [Wallet Storage — 2026-11-08])

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/wallet.dart';

//(VIV [Wallet Storage Class — 2026-11-08])

class WalletStorage {
  static const String _walletsKey = 'wallets';

  // Завантаження всіх збережених гаманців.
  Future<List<Wallet>> loadWallets() async {
    final preferences = await SharedPreferences.getInstance();
    final rawWallets = preferences.getStringList(_walletsKey);

    if (rawWallets == null || rawWallets.isEmpty) {
      return [];
    }

    final wallets = <Wallet>[];

    for (final rawWallet in rawWallets) {
      try {
        final json = jsonDecode(rawWallet);

        if (json is! Map<String, dynamic>) {
          continue;
        }

        wallets.add(_walletFromJson(json));
      } catch (_) {
        // Пошкоджений окремий запис не повинен
        // ламати завантаження всіх інших гаманців.
      }
    }

    return wallets;
  }

  // Повне збереження списку гаманців.
  Future<void> saveWallets(List<Wallet> wallets) async {
    final preferences = await SharedPreferences.getInstance();

    final rawWallets = wallets
        .map((wallet) => jsonEncode(_walletToJson(wallet)))
        .toList();

    await preferences.setStringList(_walletsKey, rawWallets);
  }

  // Видалення всіх збережених гаманців.
  Future<void> clearWallets() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_walletsKey);
  }

  // Перетворення Wallet -> JSON.
  Map<String, dynamic> _walletToJson(Wallet wallet) {
    return {
      'id': wallet.id,
      'name': wallet.name,
      'address': wallet.address,
      'createdAt': wallet.createdAt.toIso8601String(),
      'lastSuccessfulUpdate': wallet.lastSuccessfulUpdate?.toIso8601String(),
      'isDefault': wallet.isDefault,
      'poolId': wallet.poolId,
    };
  }

  // Перетворення JSON -> Wallet.
  Wallet _walletFromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']?.toString() ?? ''),
      lastSuccessfulUpdate: json['lastSuccessfulUpdate'] == null
          ? null
          : DateTime.parse(json['lastSuccessfulUpdate'].toString()),
      isDefault: json['isDefault'] == true,
      poolId: json['poolId']?.toString() ?? Wallet.defaultPoolId,
    );
  }
}
