//(VIV [Widget Refresh Settings Page — 2026-11-08])

import 'package:flutter/material.dart';

import '../../core/storage/widget_refresh_settings_storage.dart';
import '../../core/services/widget_refresh_scheduler.dart';
import '../../l10n/app_localizations.dart';

//(VIV [Widget Refresh Settings Page Class — 2026-11-08])

class WidgetRefreshSettingsPage extends StatefulWidget {
  const WidgetRefreshSettingsPage({super.key});

  @override
  State<WidgetRefreshSettingsPage> createState() =>
      _WidgetRefreshSettingsPageState();
}

//) VIV [Widget Refresh Settings Page Class — 2026-11-08]

//(VIV [Widget Refresh Settings Page State — 2026-11-08])

class _WidgetRefreshSettingsPageState extends State<WidgetRefreshSettingsPage> {
  final WidgetRefreshSettingsStorage _storage = WidgetRefreshSettingsStorage();

  final WidgetRefreshScheduler _scheduler = WidgetRefreshScheduler();

  int _hours = 0;
  int _minutes = 33;

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadInterval();
  }

  //(VIV [Load Widget Refresh Interval — 2026-11-08])

  Future<void> _loadInterval() async {
    final interval = await _storage.loadRefreshInterval();

    if (!mounted) {
      return;
    }

    setState(() {
      _hours = interval.inHours;
      _minutes = interval.inMinutes.remainder(60);
      _loading = false;
    });
  }

  //) VIV [Load Widget Refresh Interval — 2026-11-08]

  //(VIV [Save Widget Refresh Interval — 2026-11-08])

  Future<void> _saveInterval() async {
    if (_saving) {
      return;
    }

    final duration = Duration(hours: _hours, minutes: _minutes);

    if (duration.inSeconds <
        WidgetRefreshSettingsStorage.minimumIntervalSeconds) {
      return;
    }

    if (duration.inSeconds >
        WidgetRefreshSettingsStorage.maximumIntervalSeconds) {
      return;
    }

    setState(() {
      _saving = true;
    });

    await _storage.saveRefreshInterval(duration);

    //(VIV [Reschedule Widget Refresh After Settings Change — 2026-11-08])

    await _scheduler.scheduleFromApp();

    //) VIV [Reschedule Widget Refresh After Settings Change — 2026-11-08]

    if (!mounted) {
      return;
    }

    setState(() {
      _saving = false;
    });

    final localizations = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.widgetRefreshSaved)));
  }

  //) VIV [Save Widget Refresh Interval — 2026-11-08]

  //(VIV [Format Widget Refresh Interval — 2026-11-08])

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  //) VIV [Format Widget Refresh Interval — 2026-11-08]

  //(VIV [Build Widget Refresh Duration — 2026-11-08])

  Duration _buildDuration() {
    return Duration(hours: _hours, minutes: _minutes);
  }

  //) VIV [Build Widget Refresh Duration — 2026-11-08]

  //(VIV [Set Widget Refresh Duration — 2026-11-08])

  void _setDuration(Duration duration) {
    var seconds = duration.inMinutes * 60;

    if (seconds < WidgetRefreshSettingsStorage.minimumIntervalSeconds) {
      seconds = WidgetRefreshSettingsStorage.minimumIntervalSeconds;
    }

    if (seconds > WidgetRefreshSettingsStorage.maximumIntervalSeconds) {
      seconds = WidgetRefreshSettingsStorage.maximumIntervalSeconds;
    }

    final normalizedDuration = Duration(seconds: seconds);

    setState(() {
      _hours = normalizedDuration.inHours;
      _minutes = normalizedDuration.inMinutes.remainder(60);
    });
  }

  //) VIV [Set Widget Refresh Duration — 2026-11-08]

  //(VIV [Open Time Picker — 2026-11-08])

  Future<void> _openTimePicker() async {
    final localizations = AppLocalizations.of(context)!;

    final initialTime = TimeOfDay(hour: _hours.clamp(0, 23), minute: _minutes);

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: localizations.widgetRefreshTimePickerHint,
    );

    if (selectedTime == null || !mounted) {
      return;
    }

    _setDuration(
      Duration(hours: selectedTime.hour, minutes: selectedTime.minute),
    );
  }

  //) VIV [Open Time Picker — 2026-11-08]

  //(VIV [Build Widget Refresh Settings Page — 2026-11-08])

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final duration = _buildDuration();

    final intervalText = '${_twoDigits(_hours)}:${_twoDigits(_minutes)}';

    final isValid =
        duration.inSeconds >=
            WidgetRefreshSettingsStorage.minimumIntervalSeconds &&
        duration.inSeconds <=
            WidgetRefreshSettingsStorage.maximumIntervalSeconds;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.widgetRefreshSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.widgetRefreshIntervalTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(localizations.widgetRefreshIntervalDescription),

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      intervalText,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),

                  const SizedBox(height: 20),

                  //(VIV [Widget Refresh Time Selection — 2026-11-08])
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(localizations.widgetRefreshInterval),
                      subtitle: Text(intervalText),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _saving ? null : _openTimePicker,
                    ),
                  ),

                  //) VIV [Widget Refresh Time Selection — 2026-11-08]
                  const SizedBox(height: 16),

                  Text(
                    localizations.widgetRefreshLimits,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 20),

                  FilledButton.icon(
                    onPressed: _saving || !isValid ? null : _saveInterval,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(localizations.widgetRefreshSave),
                  ),

                  if (!isValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        localizations.widgetRefreshInvalidInterval,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //) VIV [Build Widget Refresh Settings Page — 2026-11-08]
}

//) VIV [Widget Refresh Settings Page State — 2026-11-08]

//) VIV [Widget Refresh Settings Page — 2026-11-08]
