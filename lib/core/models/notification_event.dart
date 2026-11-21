//(VIV [Notification Event — 2026-10-12])

class NotificationEvent {
  const NotificationEvent({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.title,
    required this.message,
    this.walletId,
  });

  final String id;
  final DateTime timestamp;
  final String type;
  final String title;
  final String message;

  /// ID гаманця, до якого належить подія.
  /// null підтримується для сумісності зі старими записами.
  final String? walletId;

  //(VIV [Notification Event Serialization — 2026-10-12])

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'title': title,
      'message': message,
      'walletId': walletId,
    };
  }

  //) VIV [Notification Event Serialization — 2026-10-12]

  //(VIV [Notification Event Deserialization — 2026-10-12])

  factory NotificationEvent.fromJson(Map<String, dynamic> json) {
    return NotificationEvent(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      walletId: json['walletId'] as String?,
    );
  }

  //) VIV [Notification Event Deserialization — 2026-10-12]
}

//) VIV [Notification Event — 2026-10-12]
