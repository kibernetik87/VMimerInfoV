//(VIV [Payment Entity — 2026-10-04])

class Payment {
  const Payment({
    required this.type,
    required this.timestamp,
    required this.amount,
    required this.txnHash,
    required this.mixin,
  });

  // Тип виплати, наприклад pplns.
  final String type;

  // Час виплати.
  final DateTime timestamp;

  // Сума виплати в XMR.
  final double amount;

  // Hash транзакції.
  final String txnHash;

  // Mixin транзакції.
  final int mixin;
}
