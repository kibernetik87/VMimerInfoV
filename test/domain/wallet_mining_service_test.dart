//(VIV [Wallet Mining Service Test — 2026-10-04])

import 'package:flutter_test/flutter_test.dart';
import 'package:vmimerinfov/domain/entities/hashrate_history.dart';
import 'package:vmimerinfov/domain/entities/payment.dart';
import 'package:vmimerinfov/domain/entities/wallet_stats.dart';
import 'package:vmimerinfov/domain/entities/worker.dart';
import 'package:vmimerinfov/domain/entities/worker_hashrate_history.dart';
import 'package:vmimerinfov/domain/repositories/mining_pool_repository.dart';
import 'package:vmimerinfov/domain/services/wallet_mining_service.dart';

class FakeMiningPoolRepository implements MiningPoolRepository {
  String? lastWalletAddress;

  final WalletStats walletStats = const WalletStats(
    hashRate: 15733.8398828125,
    hashRate2: 17774.541666666668,
    totalHashes: 323655550594,
    validShares: 904955,
    invalidShares: 183,
    amountPaid: 22.948515838,
    amountDue: 26.359262877,
    transactionCount: 3,
  );

  @override
  Future<WalletStats> getWalletStats(String walletAddress) async {
    lastWalletAddress = walletAddress;
    return walletStats;
  }

  @override
  Future<List<Worker>> getWorkers(String walletAddress) async {
    lastWalletAddress = walletAddress;
    return const <Worker>[];
  }

  //(VIV [Get Worker Hashrate History Test Fake — 2026-10-04])

  @override
  Future<List<WorkerHashrateHistory>> getWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  ) async {
    lastWalletAddress = walletAddress;
    return const <WorkerHashrateHistory>[];
  }

  //(VIV [Get Payments Test Fake — 2026-10-04])

  @override
  Future<List<Payment>> getPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  }) async {
    lastWalletAddress = walletAddress;
    return const <Payment>[];
  }

  @override
  Future<List<HashrateHistory>> getHashrateHistory(String walletAddress) async {
    lastWalletAddress = walletAddress;
    return const <HashrateHistory>[];
  }
}

void main() {
  test('WalletMiningService loads wallet stats', () async {
    final repository = FakeMiningPoolRepository();

    final service = WalletMiningService(repository: repository);

    const walletAddress = 'test-wallet-address';

    final result = await service.loadWalletStats(walletAddress);

    expect(repository.lastWalletAddress, walletAddress);
    expect(result.hashRate, 15733.8398828125);
    expect(result.hashRate2, 17774.541666666668);
    expect(result.totalHashes, 323655550594);
    expect(result.validShares, 904955);
    expect(result.invalidShares, 183);
    expect(result.amountPaid, 22.948515838);
    expect(result.amountDue, 26.359262877);
    expect(result.transactionCount, 3);
  });
}
