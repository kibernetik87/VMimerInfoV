//(VIV [MoneroOcean Hashrate Point Model — 2026-10-04])

class MoneroOceanHashratePointModel {
  const MoneroOceanHashratePointModel({
    required this.timestamp,
    required this.hashRate,
    required this.hashRate2,
  });

  final DateTime timestamp;
  final double hashRate;
  final double hashRate2;

  factory MoneroOceanHashratePointModel.fromJson(Map<String, dynamic> json) {
    return MoneroOceanHashratePointModel(
      //(VIV [Timestamp Is Milliseconds — 2026-10-04])
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        _toNum(json['ts']).toInt(),
      ),
      hashRate: _toNum(json['hs']).toDouble(),
      hashRate2: _toNum(json['hs2']).toDouble(),
    );
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
