//(VIV [MoneroOcean Adapter — 2026-10-04])

import '../../../domain/entities/hashrate_history.dart';
import '../../../domain/entities/payment.dart';
import '../../../domain/entities/wallet_stats.dart';
import '../../../domain/entities/worker.dart';
import '../../../domain/entities/worker_hashrate_history.dart';
import '../../../domain/repositories/mining_pool_adapter.dart';
import 'moneroocean_api_client.dart';

class MoneroOceanAdapter implements MiningPoolAdapter {
  MoneroOceanAdapter({required this._apiClient});

  final MoneroOceanApiClient _apiClient;

  @override
  String get poolName => 'MoneroOcean';

  @override
  Future<WalletStats> getWalletStats(String walletAddress) async {
    final model = await _apiClient.getWalletStats(walletAddress);

    return model.toEntity();
  }

  //(VIV [Get Workers — 2026-10-03])

  @override
  Future<List<Worker>> getWorkers(String walletAddress) async {
    final models = await _apiClient.getWorkers(walletAddress);

    final now = DateTime.now();

    return models.map((model) => model.toEntity(now: now)).toList();
  }

  //(VIV [Get Worker Hashrate History — 2026-10-04])

  @override
  Future<List<WorkerHashrateHistory>> getWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  ) async {
    final models = await _apiClient.getWorkerHashrateHistory(
      walletAddress,
      workerIdentifier,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  //(VIV [Get Payments — 2026-10-04])

  @override
  Future<List<Payment>> getPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  }) async {
    final models = await _apiClient.getPayments(
      walletAddress,
      page: page,
      limit: limit,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<HashrateHistory>> getHashrateHistory(String walletAddress) async {
    final models = await _apiClient.getHashrateHistory(walletAddress);

    return models
        .map(
          (model) => HashrateHistory(
            timestamp: model.timestamp,
            hashRate: model.hashRate,
            hashRate2: model.hashRate2,
          ),
        )
        .toList();
  }
}
