//(VIV [Wallet Mining Service — 2026-10-04])

import '../entities/hashrate_history.dart';
import '../entities/payment.dart';
import '../entities/wallet_stats.dart';
import '../entities/worker.dart';
import '../entities/worker_hashrate_history.dart';
import '../repositories/mining_pool_repository.dart';
import 'wallet_mining_service_contract.dart';

class WalletMiningService implements WalletMiningServiceContract {
  WalletMiningService({required this.repository});

  final MiningPoolRepository repository;

  @override
  Future<WalletStats> loadWalletStats(String walletAddress) {
    return repository.getWalletStats(walletAddress);
  }

  //(VIV [Load Workers — 2026-10-03])

  @override
  Future<List<Worker>> loadWorkers(String walletAddress) {
    return repository.getWorkers(walletAddress);
  }

  //(VIV [Load Worker Hashrate History — 2026-10-04])

  @override
  Future<List<WorkerHashrateHistory>> loadWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  ) {
    return repository.getWorkerHashrateHistory(walletAddress, workerIdentifier);
  }

  //(VIV [Load Payments — 2026-10-04])

  @override
  Future<List<Payment>> loadPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  }) {
    return repository.getPayments(walletAddress, page: page, limit: limit);
  }

  //(VIV [Load Hashrate History — 2026-10-04])

  @override
  Future<List<HashrateHistory>> loadHashrateHistory(String walletAddress) {
    return repository.getHashrateHistory(walletAddress);
  }
}
