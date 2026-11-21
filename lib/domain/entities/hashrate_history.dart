//(VIV [Hashrate History Entity — 2026-10-03])

class HashrateHistory {
  const HashrateHistory({
    required this.timestamp,
    required this.hashRate,
    required this.hashRate2,
  });

  final DateTime timestamp;
  final double hashRate;
  final double hashRate2;
}
