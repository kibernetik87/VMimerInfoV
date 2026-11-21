//(VIV [Background Monitor Service — 2026-11-02])

import 'package:workmanager/workmanager.dart';

import 'widget_refresh_scheduler.dart';
import 'widget_refresh_worker_callback.dart';

//(VIV [VMimerInfoV Workmanager Dispatcher — 2026-11-02])

@pragma('vm:entry-point')
void vmimerInfoVWorkmanagerCallback() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case widgetRefreshTaskName:
        return runWidgetRefreshTask(inputData);

      default:
        return false;
    }
  });
}

//) VIV [VMimerInfoV Workmanager Dispatcher — 2026-11-02]

//(VIV [Background Monitor Service Class — 2026-11-02])

class BackgroundMonitorService {
  BackgroundMonitorService();

  //(VIV [Initialize Workmanager — 2026-11-02])

  Future<void> initialize() async {
    await Workmanager().initialize(vmimerInfoVWorkmanagerCallback);
  }

  //) VIV [Initialize Workmanager — 2026-11-02]
}

//) VIV [Background Monitor Service Class — 2026-11-02]

//) VIV [Background Monitor Service — 2026-11-02]
