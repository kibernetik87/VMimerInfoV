//(VIV [Mining Pool Adapter — 2026-10-04])

import '../entities/hashrate_history.dart';
import '../entities/payment.dart';
import '../entities/wallet_stats.dart';
import '../entities/worker.dart';
import '../entities/worker_hashrate_history.dart';

abstract class MiningPoolAdapter {
  String get poolName;

  Future<WalletStats> getWalletStats(String walletAddress);

  Future<List<Worker>> getWorkers(String walletAddress);

  //(VIV [Get Worker Hashrate History — 2026-10-04])

  Future<List<WorkerHashrateHistory>> getWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  );

  //(VIV [Get Payments — 2026-10-04])

  Future<List<Payment>> getPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  });

  Future<List<HashrateHistory>> getHashrateHistory(String walletAddress);
}
