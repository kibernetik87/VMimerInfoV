//(VIV [Wallet Mining Snapshot — 2026-10-05])

//(VIV [Wallet Mining Snapshot Class — 2026-10-05])
class WalletMiningSnapshot {
  const WalletMiningSnapshot({
    required this.walletId,
    required this.walletAddress,
    required this.hashRate,
    required this.hashRate2,
    required this.workersOnline,
    required this.workersTotal,
    required this.amountPaid,
    required this.amountDue,
    required this.updatedAt,
  });

  final String walletId;
  final String walletAddress;

  final double hashRate;
  final double hashRate2;

  final int workersOnline;
  final int workersTotal;

  final double amountPaid;
  final double amountDue;

  final DateTime updatedAt;
}
//) VIV [Wallet Mining Snapshot Class — 2026-10-05]

//) VIV [Wallet Mining Snapshot — 2026-10-05]
