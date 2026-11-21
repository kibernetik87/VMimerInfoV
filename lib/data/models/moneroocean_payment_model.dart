//(VIV [MoneroOcean Payment Model — 2026-10-04])

import '../../domain/entities/payment.dart';

//(VIV [MoneroOcean Payment Model Class — 2026-10-04])

class MoneroOceanPaymentModel {
  const MoneroOceanPaymentModel({
    required this.type,
    required this.timestamp,
    required this.amount,
    required this.txnHash,
    required this.mixin,
  });

  final String type;
  final int timestamp;
  final num amount;
  final String txnHash;
  final int mixin;

  // Перетворення JSON MoneroOcean -> Model.
  factory MoneroOceanPaymentModel.fromJson(Map<String, dynamic> json) {
    return MoneroOceanPaymentModel(
      type: json['pt']?.toString() ?? '',
      timestamp: _toNum(json['ts']).toInt(),
      amount: _toNum(json['amount']),
      txnHash: json['txnHash']?.toString() ?? '',
      mixin: _toNum(json['mixin']).toInt(),
    );
  }

  // Перетворення Model -> Domain Entity.
  Payment toEntity() {
    return Payment(
      type: type,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),

      //(VIV [Piconero To XMR — 2026-10-04])
      // MoneroOcean повертає amount у piconero.
      // 1 XMR = 1 000 000 000 000 piconero.
      amount: amount.toDouble() / 1000000000000,

      txnHash: txnHash,
      mixin: mixin,
    );
  }

  // Безпечне перетворення числових значень API.
  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
