//(VIV [Widget Config Native Storage — 2026-10-05])

import 'package:flutter/services.dart';

//(VIV [Widget Config Native Storage Class — 2026-10-05])

class WidgetConfigNativeStorage {
  WidgetConfigNativeStorage();

  static const MethodChannel _channel = MethodChannel(
    'com.example.vmimerinfov/widget_config',
  );

  //(VIV [Load All Widget Wallets — 2026-10-05])

  Future<Map<int, String>> loadAllWidgetWallets() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>>(
      'loadAllWidgetWallets',
    );

    if (result == null) {
      return <int, String>{};
    }

    final widgetWallets = <int, String>{};

    for (final entry in result.entries) {
      final appWidgetId = _parseWidgetId(entry.key);
      final walletId = entry.value?.toString();

      if (appWidgetId == null || walletId == null || walletId.isEmpty) {
        continue;
      }

      widgetWallets[appWidgetId] = walletId;
    }

    return widgetWallets;
  }

  //) VIV [Load All Widget Wallets — 2026-10-05]

  //(VIV [Parse Widget ID — 2026-10-05])

  int? _parseWidgetId(Object? value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '');
  }

  //) VIV [Parse Widget ID — 2026-10-05]
}

//) VIV [Widget Config Native Storage Class — 2026-10-05]

//) VIV [Widget Config Native Storage — 2026-10-05]
