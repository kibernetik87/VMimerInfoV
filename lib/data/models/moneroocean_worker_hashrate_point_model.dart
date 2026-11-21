//(VIV [MoneroOcean Worker Hashrate Point Model — 2026-10-04])

import '../../domain/entities/worker_hashrate_history.dart';

class MoneroOceanWorkerHashratePointModel {
  const MoneroOceanWorkerHashratePointModel({
    required this.timestamp,
    required this.hashRate,
    required this.hashRate2,
  });

  final DateTime timestamp;

  final double hashRate;

  final double hashRate2;

  factory MoneroOceanWorkerHashratePointModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MoneroOceanWorkerHashratePointModel(
      //(VIV [Worker History Timestamp Is Milliseconds — 2026-10-04])
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        _toNum(json['ts']).toInt(),
      ),

      //(VIV [Worker History Hashrate — 2026-10-04])
      hashRate: _toNum(json['hs']).toDouble(),

      //(VIV [Worker History Hashrate2 — 2026-10-04])
      hashRate2: _toNum(json['hs2']).toDouble(),
    );
  }

  WorkerHashrateHistory toEntity() {
    return WorkerHashrateHistory(
      timestamp: timestamp,
      hashRate: hashRate,
      hashRate2: hashRate2,
    );
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
