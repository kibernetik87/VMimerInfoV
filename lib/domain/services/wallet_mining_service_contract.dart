//(VIV [Wallet Mining Service Contract — 2026-10-04])

import '../entities/hashrate_history.dart';
import '../entities/payment.dart';
import '../entities/wallet_stats.dart';
import '../entities/worker.dart';
import '../entities/worker_hashrate_history.dart';

abstract class WalletMiningServiceContract {
  Future<WalletStats> loadWalletStats(String walletAddress);

  Future<List<Worker>> loadWorkers(String walletAddress);

  //(VIV [Load Worker Hashrate History — 2026-10-04])

  Future<List<WorkerHashrateHistory>> loadWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  );

  //(VIV [Load Payments — 2026-10-04])

  Future<List<Payment>> loadPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  });

  //(VIV [Load Hashrate History — 2026-10-04])

  Future<List<HashrateHistory>> loadHashrateHistory(String walletAddress);
}
