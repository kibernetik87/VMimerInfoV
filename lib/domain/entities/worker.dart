//(VIV [Worker Entity — 2026-10-03])

enum WorkerStatus { online, zeroHashrate, offline }

class Worker {
  const Worker({
    required this.identifier,
    required this.hashRate,
    required this.hashRate2,
    required this.totalHash,
    required this.validShares,
    required this.invalidShares,
    required this.lastSeen,
    required this.status,
  });

  final String identifier;
  final double hashRate;
  final double hashRate2;
  final double totalHash;
  final int validShares;
  final int invalidShares;
  final DateTime lastSeen;
  final WorkerStatus status;
}
