//(VIV [Wallet Stats Entity — 2026-10-03])

class WalletStats {
  const WalletStats({
    this.hashRate = 0,
    this.hashRate2 = 0,
    this.totalHashes = 0,
    this.validShares = 0,
    this.invalidShares = 0,
    this.amountPaid = 0,
    this.amountDue = 0,
    this.transactionCount = 0,
  });

  final double hashRate;
  final double hashRate2;
  final int totalHashes;
  final int validShares;
  final int invalidShares;
  final double amountPaid;
  final double amountDue;
  final int transactionCount;
}
