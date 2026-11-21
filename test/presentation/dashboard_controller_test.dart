//(VIV [Dashboard Controller Test — 2026-10-04])

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vmimerinfov/core/storage/wallet_storage.dart';
import 'package:vmimerinfov/domain/entities/hashrate_history.dart';
import 'package:vmimerinfov/domain/entities/payment.dart';
import 'package:vmimerinfov/domain/entities/wallet_stats.dart';
import 'package:vmimerinfov/domain/entities/worker.dart';
import 'package:vmimerinfov/domain/entities/worker_hashrate_history.dart';
import 'package:vmimerinfov/domain/services/wallet_mining_service_contract.dart';
import 'package:vmimerinfov/presentation/dashboard/dashboard_controller.dart';

//(VIV [Fake Wallet Mining Service — 2026-10-04])

class FakeWalletMiningService implements WalletMiningServiceContract {
  FakeWalletMiningService(this.future);

  final Future<WalletStats> future;
  String? lastWalletAddress;

  @override
  Future<WalletStats> loadWalletStats(String walletAddress) {
    lastWalletAddress = walletAddress;
    return future;
  }

  //(VIV [Fake Load Workers — 2026-10-03])

  @override
  Future<List<Worker>> loadWorkers(String walletAddress) {
    return Future.value(<Worker>[]);
  }

  //(VIV [Fake Load Worker Hashrate History — 2026-10-04])

  @override
  Future<List<WorkerHashrateHistory>> loadWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  ) {
    return Future.value(<WorkerHashrateHistory>[]);
  }

  //(VIV [Fake Load Payments — 2026-10-04])

  @override
  Future<List<Payment>> loadPayments(
    String walletAddress, {
    int page = 0,
    int limit = 15,
  }) {
    return Future.value(<Payment>[]);
  }

  //(VIV [Fake Load Hashrate History — 2026-10-04])

  @override
  Future<List<HashrateHistory>> loadHashrateHistory(String walletAddress) {
    return Future.value(<HashrateHistory>[]);
  }
}

void main() {
  group('DashboardController', () {
    test('loads wallet and changes status from loading to loaded', () async {
      final completer = Completer<WalletStats>();

      final service = FakeWalletMiningService(completer.future);

      final controller = DashboardController(
        service: service,
        walletStorage: WalletStorage(),
        poolNameFor: (_) => null,
      );

      final loadFuture = controller.loadWallet('test-wallet');

      expect(controller.status, DashboardStatus.loading);
      expect(service.lastWalletAddress, 'test-wallet');
      expect(controller.walletStats, isNull);
      expect(controller.errorMessage, isNull);

      final stats = const WalletStats(
        hashRate: 15733.8398828125,
        hashRate2: 17774.541666666668,
        totalHashes: 323655550594,
        validShares: 904955,
        invalidShares: 183,
        amountPaid: 22.948515838,
        amountDue: 26.359262877,
        transactionCount: 3,
      );

      completer.complete(stats);
      await loadFuture;

      expect(controller.status, DashboardStatus.loaded);
      expect(controller.walletStats, same(stats));
      expect(controller.errorMessage, isNull);
    });

    test('changes status to error when service fails', () async {
      final service = FakeWalletMiningService(
        Future<WalletStats>.error(Exception('API unavailable')),
      );

      final controller = DashboardController(
        service: service,
        walletStorage: WalletStorage(),
        poolNameFor: (_) => null,
      );

      await controller.loadWallet('test-wallet');

      expect(controller.status, DashboardStatus.error);
      expect(controller.walletStats, isNull);
      expect(controller.errorMessage, contains('API unavailable'));
    });
  });
}

//) VIV [Dashboard Controller Test — 2026-10-04]
