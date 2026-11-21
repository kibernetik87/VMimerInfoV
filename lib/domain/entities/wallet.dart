//(VIV [Wallet Entity — 2026-11-08])

class Wallet {
  static const String defaultPoolId = 'moneroocean';

  const Wallet({
    required this.id,
    required this.name,
    required this.address,
    required this.createdAt,
    this.lastSuccessfulUpdate,
    this.isDefault = false,
    this.poolId = defaultPoolId,
  });

  final String id;
  final String name;
  final String address;
  final DateTime createdAt;
  final DateTime? lastSuccessfulUpdate;
  final bool isDefault;

  // Ідентифікатор майнінг-пулу.
  final String poolId;
}
