//(VIV [Widget Refresh Bridge — 2026-10-05])

import 'package:flutter/services.dart';

//(VIV [Widget Refresh Bridge Class — 2026-10-05])

class WidgetRefreshBridge {
  WidgetRefreshBridge();

  static const MethodChannel _channel = MethodChannel(
    'com.example.vmimerinfov/widget_refresh_bridge',
  );

  //(VIV [Update All Widgets — 2026-10-05])

  Future<void> updateAllWidgets() async {
    await _channel.invokeMethod<void>(
      'updateAllWidgets',
    );
  }

//) VIV [Update All Widgets — 2026-10-05]
}

//) VIV [Widget Refresh Bridge Class — 2026-10-05]

//) VIV [Widget Refresh Bridge — 2026-10-05]
