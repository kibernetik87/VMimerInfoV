//(VIV [MoneroOcean Repository Test — 2026-10-03])

import 'package:flutter_test/flutter_test.dart';
import 'package:vmimerinfov/data/datasources/moneroocean/moneroocean_adapter.dart';
import 'package:vmimerinfov/data/datasources/moneroocean/moneroocean_api_client.dart';
import 'package:vmimerinfov/data/repositories/moneroocean_repository.dart';
import 'package:vmimerinfov/domain/entities/hashrate_history.dart';
import 'package:vmimerinfov/domain/entities/wallet_stats.dart';
import 'package:vmimerinfov/domain/entities/worker.dart';

class FakeMoneroOceanAdapter extends MoneroOceanAdapter {
  FakeMoneroOceanAdapter() : super(apiClient: MoneroOceanApiClient());

  final WalletStats walletStats = const WalletStats(
    hashRate: 15000,
    hashRate2: 17000,
    totalHashes: 123456,
    validShares: 100,
    invalidShares: 2,
    amountPaid: 10,
    amountDue: 1,
    transactionCount: 3,
  );

  @override
  Future<WalletStats> getWalletStats(String walletAddress) async {
    return walletStats;
  }

  @override
  Future<List<Worker>> getWorkers(String walletAddress) async {
    return const <Worker>[];
  }

  @override
  Future<List<HashrateHistory>> getHashrateHistory(String walletAddress) async {
    return const <HashrateHistory>[];
  }
}

void main() {
  test('MoneroOceanRepository returns wallet stats from adapter', () async {
    final adapter = FakeMoneroOceanAdapter();

    final repository = MoneroOceanRepository(adapter: adapter);

    final result = await repository.getWalletStats('test-wallet');

    expect(result.hashRate, 15000);
    expect(result.hashRate2, 17000);
    expect(result.totalHashes, 123456);
    expect(result.validShares, 100);
    expect(result.invalidShares, 2);
    expect(result.amountPaid, 10);
    expect(result.amountDue, 1);
    expect(result.transactionCount, 3);
  });
}
