//(VIV [Worker Hashrate History Entity — 2026-10-04])

class WorkerHashrateHistory {
  const WorkerHashrateHistory({
    required this.timestamp,
    required this.hashRate,
    required this.hashRate2,
  });

  final DateTime timestamp;

  final double hashRate;

  final double hashRate2;
}
