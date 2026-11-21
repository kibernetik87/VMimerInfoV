//(VIV [Hashrate Controller Test — 2026-10-04])

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vmimerinfov/core/storage/wallet_storage.dart';
import 'package:vmimerinfov/domain/entities/hashrate_history.dart';
import 'package:vmimerinfov/domain/entities/payment.dart';
import 'package:vmimerinfov/domain/entities/wallet.dart';
import 'package:vmimerinfov/domain/entities/wallet_stats.dart';
import 'package:vmimerinfov/domain/entities/worker.dart';
import 'package:vmimerinfov/domain/entities/worker_hashrate_history.dart';
import 'package:vmimerinfov/domain/services/wallet_mining_service_contract.dart';
import 'package:vmimerinfov/presentation/hashrate/hashrate_controller.dart';

//(VIV [Fake Wallet Mining Service — 2026-10-04])

class FakeWalletMiningService implements WalletMiningServiceContract {
  FakeWalletMiningService({
    this.history = const <HashrateHistory>[],
    this.error,
  });

  final List<HashrateHistory> history;
  final Object? error;

  String? lastWalletAddress;
  int loadHashrateHistoryCalls = 0;

  @override
  Future<WalletStats> loadWalletStats(String walletAddress) {
    throw UnimplementedError();
  }

  @override
  Future<List<Worker>> loadWorkers(String walletAddress) {
    throw UnimplementedError();
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
  Future<List<HashrateHistory>> loadHashrateHistory(
    String walletAddress,
  ) async {
    lastWalletAddress = walletAddress;
    loadHashrateHistoryCalls++;

    if (error != null) {
      throw error!;
    }

    return history;
  }
}

//(VIV [Test Wallet Factory — 2026-10-04])

Wallet createTestWallet({required bool isDefault}) {
  return Wallet(
    id: 'wallet-1',
    name: 'Основний',
    address: 'test-wallet',
    createdAt: DateTime(2026, 10, 4),
    isDefault: isDefault,
  );
}

Future<WalletStorage> prepareWalletStorage(List<Wallet> wallets) async {
  SharedPreferences.setMockInitialValues({});

  final storage = WalletStorage();

  await storage.saveWallets(wallets);

  return storage;
}

void main() {
  group('HashrateController', () {
    test('loads hashrate history from default wallet', () async {
      final history = <HashrateHistory>[
        HashrateHistory(
          timestamp: DateTime(2026, 10, 4, 12, 0),
          hashRate: 1500,
          hashRate2: 1600,
        ),
        HashrateHistory(
          timestamp: DateTime(2026, 10, 4, 12, 5),
          hashRate: 1700,
          hashRate2: 1800,
        ),
      ];

      final service = FakeWalletMiningService(history: history);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = HashrateController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, HashrateStatus.loaded);
      expect(controller.walletAddress, 'test-wallet');
      expect(controller.history, same(history));
      expect(service.lastWalletAddress, 'test-wallet');
      expect(service.loadHashrateHistoryCalls, 1);
      expect(controller.errorMessage, isNull);
    });

    test('changes status to noWallet when default wallet is missing', () async {
      final service = FakeWalletMiningService();

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: false),
      ]);

      final controller = HashrateController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, HashrateStatus.noWallet);
      expect(controller.walletAddress, isNull);
      expect(controller.history, isEmpty);
      expect(controller.errorMessage, isNull);
      expect(service.loadHashrateHistoryCalls, 0);
    });

    test('changes status to error when service fails', () async {
      final service = FakeWalletMiningService(
        error: Exception('API unavailable'),
      );

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = HashrateController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, HashrateStatus.error);
      expect(controller.errorMessage, contains('API unavailable'));
      expect(controller.history, isEmpty);
      expect(service.loadHashrateHistoryCalls, 1);
    });

    test('refresh loads hashrate history again', () async {
      final history = <HashrateHistory>[
        HashrateHistory(
          timestamp: DateTime(2026, 10, 4, 12, 0),
          hashRate: 1500,
          hashRate2: 1600,
        ),
      ];

      final service = FakeWalletMiningService(history: history);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = HashrateController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(service.loadHashrateHistoryCalls, 1);

      await controller.refresh();

      expect(service.loadHashrateHistoryCalls, 2);
      expect(controller.status, HashrateStatus.loaded);
      expect(controller.history, same(history));
    });
  });
}
