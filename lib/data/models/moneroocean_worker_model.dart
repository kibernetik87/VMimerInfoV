//(VIV [MoneroOcean Worker Model — 2026-10-04])

import '../../domain/entities/worker.dart';

class MoneroOceanWorkerModel {
  const MoneroOceanWorkerModel({
    required this.identifier,
    required this.hash,
    required this.hash2,
    required this.totalHash,
    required this.validShares,
    required this.invalidShares,
    required this.lastSeen,
  });

  final String identifier;
  final num hash;
  final num hash2;
  final num totalHash;
  final int validShares;
  final int invalidShares;
  final int lastSeen;

  factory MoneroOceanWorkerModel.fromJson(Map<String, dynamic> json) {
    return MoneroOceanWorkerModel(
      identifier: _readIdentifier(json),
      hash: _toNum(json['hash']),
      hash2: _toNum(json['hash2']),
      totalHash: _toNum(json['totalHash']),
      validShares: _toNum(json['validShares']).toInt(),
      invalidShares: _toNum(json['invalidShares']).toInt(),
      lastSeen: _toNum(json['lts']).toInt(),
    );
  }

  Worker toEntity({
    required DateTime now,
    Duration offlineAfter = const Duration(minutes: 15),
  }) {
    final lastSeenDate = DateTime.fromMillisecondsSinceEpoch(lastSeen * 1000);

    final isStale = now.difference(lastSeenDate) > offlineAfter;

    final WorkerStatus status;

    if (isStale) {
      status = WorkerStatus.offline;
    } else if (hash <= 0) {
      status = WorkerStatus.zeroHashrate;
    } else {
      status = WorkerStatus.online;
    }

    return Worker(
      identifier: identifier,
      hashRate: hash.toDouble(),
      hashRate2: hash2.toDouble(),
      totalHash: totalHash.toDouble(),
      validShares: validShares,
      invalidShares: invalidShares,
      lastSeen: lastSeenDate,
      status: status,
    );
  }

  static String _readIdentifier(Map<String, dynamic> json) {
    return json['identifier']?.toString() ??
        json['identifer']?.toString() ??
        '';
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
