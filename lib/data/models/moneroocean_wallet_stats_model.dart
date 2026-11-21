//(VIV [MoneroOcean Wallet Stats Model — 2026-10-03])

import '../../domain/entities/wallet_stats.dart';

class MoneroOceanWalletStatsModel {
  const MoneroOceanWalletStatsModel({
    required this.hash,
    required this.hash2,
    required this.identifier,
    required this.lastHash,
    required this.totalHashes,
    required this.validShares,
    required this.invalidShares,
    required this.amtPaid,
    required this.amtDue,
    required this.txnCount,
  });

  final num hash;
  final num hash2;
  final String identifier;
  final num lastHash;
  final num totalHashes;
  final num validShares;
  final num invalidShares;
  final num amtPaid;
  final num amtDue;
  final num txnCount;

  factory MoneroOceanWalletStatsModel.fromJson(Map<String, dynamic> json) {
    return MoneroOceanWalletStatsModel(
      hash: _toNum(json['hash']),
      hash2: _toNum(json['hash2']),
      identifier: json['identifier']?.toString() ?? '',
      lastHash: _toNum(json['lastHash']),
      totalHashes: _toNum(json['totalHashes']),
      validShares: _toNum(json['validShares']),
      invalidShares: _toNum(json['invalidShares']),
      amtPaid: _toNum(json['amtPaid']),
      amtDue: _toNum(json['amtDue']),
      txnCount: _toNum(json['txnCount']),
    );
  }

  WalletStats toEntity() {
    return WalletStats(
      hashRate: hash.toDouble(),
      hashRate2: hash2.toDouble(),
      totalHashes: totalHashes.toInt(),
      validShares: validShares.toInt(),
      invalidShares: invalidShares.toInt(),

      //(VIV [MoneroOcean XMR Amount Conversion — 2026-10-03])
      //
      // MoneroOcean's amtPaid and amtDue values used by this API
      // require conversion with a 1,000,000,000,000 scale factor.
      //
      // Example:
      // 26486271132 / 1,000,000,000,000
      // = 0.026486271132 XMR
      amountPaid: amtPaid.toDouble() / 1000000000000,
      amountDue: amtDue.toDouble() / 1000000000000,

      transactionCount: txnCount.toInt(),
    );
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
