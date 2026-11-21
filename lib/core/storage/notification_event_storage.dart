//(VIV [Notification Event Storage — 2026-10-12])

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_event.dart';

//(VIV [Notification Event Storage Class — 2026-10-12])

class NotificationEventStorage {
  static const String _eventsKey = 'notification_events';
  static const int _maxEvents = 100;

  //(VIV [Load Notification Events — 2026-10-12])

  Future<List<NotificationEvent>> loadEvents({String? walletId}) async {
    final preferences = await SharedPreferences.getInstance();
    final rawEvents = preferences.getStringList(_eventsKey);

    if (rawEvents == null || rawEvents.isEmpty) {
      return [];
    }

    final events = <NotificationEvent>[];

    for (final rawEvent in rawEvents) {
      try {
        final decoded = jsonDecode(rawEvent) as Map<String, dynamic>;
        final event = NotificationEvent.fromJson(decoded);

        if (walletId == null || event.walletId == walletId) {
          events.add(event);
        }
      } catch (_) {
        // Пошкоджений запис журналу просто пропускаємо.
      }
    }

    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return events;
  }

  //) VIV [Load Notification Events — 2026-10-12]

  //(VIV [Add Notification Event — 2026-10-12])

  Future<void> addEvent(NotificationEvent event) async {
    final preferences = await SharedPreferences.getInstance();
    final rawEvents = preferences.getStringList(_eventsKey) ?? [];

    rawEvents.insert(0, jsonEncode(event.toJson()));

    if (rawEvents.length > _maxEvents) {
      rawEvents.removeRange(_maxEvents, rawEvents.length);
    }

    await preferences.setStringList(_eventsKey, rawEvents);
  }

  //) VIV [Add Notification Event — 2026-10-12]

  //(VIV [Clear Notification Events — 2026-10-12])

  /// Очищає весь журнал, якщо walletId не переданий.
  /// Якщо переданий walletId — видаляє лише події цього гаманця.
  Future<void> clearEvents({String? walletId}) async {
    final preferences = await SharedPreferences.getInstance();

    if (walletId == null) {
      await preferences.remove(_eventsKey);
      return;
    }

    final rawEvents = preferences.getStringList(_eventsKey);

    if (rawEvents == null || rawEvents.isEmpty) {
      return;
    }

    final remainingEvents = <String>[];

    for (final rawEvent in rawEvents) {
      try {
        final decoded = jsonDecode(rawEvent) as Map<String, dynamic>;
        final event = NotificationEvent.fromJson(decoded);

        if (event.walletId != walletId) {
          remainingEvents.add(rawEvent);
        }
      } catch (_) {
        // Не видаляємо пошкоджені записи під час очищення одного гаманця.
        remainingEvents.add(rawEvent);
      }
    }

    if (remainingEvents.isEmpty) {
      await preferences.remove(_eventsKey);
    } else {
      await preferences.setStringList(_eventsKey, remainingEvents);
    }
  }

  //) VIV [Clear Notification Events — 2026-10-12]

  //(VIV [Remove Wallet Notification Events — 2026-10-12])

  Future<void> removeWalletEvents(String walletId) async {
    await clearEvents(walletId: walletId);
  }

  //) VIV [Remove Wallet Notification Events — 2026-10-12]
}

//) VIV [Notification Event Storage Class — 2026-10-12]

//) VIV [Notification Event Storage — 2026-10-12]
