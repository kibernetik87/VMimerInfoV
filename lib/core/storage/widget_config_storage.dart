//(VIV [Widget Config Storage — 2026-10-05])

import 'package:shared_preferences/shared_preferences.dart';

//(VIV [Widget Config Storage Class — 2026-10-05])

class WidgetConfigStorage {
  static const String _prefix = 'widget_wallet_';

  //(VIV [Save Widget Wallet — 2026-10-05])

  Future<void> saveWalletId({
    required int appWidgetId,
    required String walletId,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString('$_prefix$appWidgetId', walletId);
  }

  //) VIV [Save Widget Wallet — 2026-10-05]

  //(VIV [Load Widget Wallet — 2026-10-05])

  Future<String?> loadWalletId({required int appWidgetId}) async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString('$_prefix$appWidgetId');
  }

  //) VIV [Load Widget Wallet — 2026-10-05]

  //(VIV [Remove Widget Wallet — 2026-10-05])

  Future<void> removeWalletId({required int appWidgetId}) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove('$_prefix$appWidgetId');
  }

  //) VIV [Remove Widget Wallet — 2026-10-05]
}

//) VIV [Widget Config Storage Class — 2026-10-05]

//) VIV [Widget Config Storage — 2026-10-05]
