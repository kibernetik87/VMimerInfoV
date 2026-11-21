//(VIV [Widget Service — 2026-10-04])

import 'package:flutter/services.dart';

//(VIV [Widget Service Class — 2026-10-04])
class WidgetService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.vmimerinfov/widget',
  );

  //(VIV [Update Widget Data — 2026-10-04])
  Future<void> updateWidgetData({
    required double hashRate,
    required double hashRate2,
    required int workersOnline,
    required int workersTotal,
    required double amountPaid,
    required double amountDue,
    required DateTime updatedAt,
  }) async {
    await _channel.invokeMethod<void>('updateWidgetData', {
      'hashRate': hashRate,
      'hashRate2': hashRate2,
      'workersOnline': workersOnline,
      'workersTotal': workersTotal,
      'amountPaid': amountPaid,
      'amountDue': amountDue,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    });
  }
}
