//(VIV [MoneroOcean Repository — 2026-10-04])

import '../../domain/entities/hashrate_history.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/wallet_stats.dart';
import '../../domain/entities/worker.dart';
import '../../domain/entities/worker_hashrate_history.dart';
import '../../domain/repositories/mining_pool_repository.dart';
import '../datasources/moneroocean/moneroocean_adapter.dart';

class MoneroOceanRepository implements MiningPoolRepository {
  MoneroOceanRepository({required this._adapter});

  final MoneroOceanAdapter _adapter;

  @override
  Future<WalletStats> getWalletStats(String walletAddress) {
    return _adapter.getWalletStats(walletAddress);
  }

  @override
  Future<List<Worker>> getWorkers(String walletAddress) {
    return _adapter.getWorkers(walletAddress);
  }

  //(VIV [Get Worker Hashrate History — 2026-10-04])

  @override
  Future<List<WorkerHashrateHistory>> getWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  ) {
    return _adapter.getWorkerHashrateHistory(walletAddress, workerIdentifier);
  }

  //(VIV [Get Payments — 2026-10-04])

  @override
  Future<List<Payment>> getPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  }) {
    return _adapter.getPayments(walletAddress, page: page, limit: limit);
  }

  @override
  Future<List<HashrateHistory>> getHashrateHistory(String walletAddress) {
    return _adapter.getHashrateHistory(walletAddress);
  }
}
