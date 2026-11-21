//(VIV [Workers Controller Test — 2026-10-04])

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
import 'package:vmimerinfov/presentation/workers/workers_controller.dart';

//(VIV [Fake Wallet Mining Service — 2026-10-04])

class FakeWalletMiningService implements WalletMiningServiceContract {
  FakeWalletMiningService({
    this.workers = const <Worker>[],
    this.workerHashrateHistory = const <WorkerHashrateHistory>[],
    this.error,
    this.workerHashrateHistoryError,
  });

  final List<Worker> workers;
  final List<WorkerHashrateHistory> workerHashrateHistory;
  final Object? error;
  final Object? workerHashrateHistoryError;

  String? lastWalletAddress;
  String? lastWorkerIdentifier;

  int loadWorkersCalls = 0;
  int loadWorkerHashrateHistoryCalls = 0;

  @override
  Future<WalletStats> loadWalletStats(String walletAddress) {
    throw UnimplementedError();
  }

  @override
  Future<List<Worker>> loadWorkers(String walletAddress) async {
    lastWalletAddress = walletAddress;
    loadWorkersCalls++;

    if (error != null) {
      throw error!;
    }

    return workers;
  }

  //(VIV [Fake Load Worker Hashrate History — 2026-10-04])

  @override
  Future<List<WorkerHashrateHistory>> loadWorkerHashrateHistory(
    String walletAddress,
    String workerIdentifier,
  ) async {
    lastWalletAddress = walletAddress;
    lastWorkerIdentifier = workerIdentifier;
    loadWorkerHashrateHistoryCalls++;

    if (workerHashrateHistoryError != null) {
      throw workerHashrateHistoryError!;
    }

    return workerHashrateHistory;
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

//(VIV [Test Wallet Factory — 2026-10-03])

Wallet createTestWallet({required bool isDefault}) {
  return Wallet(
    id: 'wallet-1',
    name: 'Основний',
    address: 'test-wallet',
    createdAt: DateTime(2026, 10, 3),
    isDefault: isDefault,
  );
}

Future<WalletStorage> prepareWalletStorage(List<Wallet> wallets) async {
  SharedPreferences.setMockInitialValues({});

  final storage = WalletStorage();

  await storage.saveWallets(wallets);

  return storage;
}

WorkerHashrateHistory createTestWorkerHashratePoint({
  required DateTime timestamp,
  required double hashRate,
  required double hashRate2,
}) {
  return WorkerHashrateHistory(
    timestamp: timestamp,
    hashRate: hashRate,
    hashRate2: hashRate2,
  );
}

void main() {
  group('WorkersController', () {
    test('loads workers from default wallet', () async {
      final workers = <Worker>[
        Worker(
          identifier: 'VIV',
          hashRate: 1929.78,
          hashRate2: 1929.77,
          totalHash: 8857800974.57,
          validShares: 106279,
          invalidShares: 86,
          lastSeen: DateTime(2026, 10, 3, 20, 0),
          status: WorkerStatus.online,
        ),
      ];

      final service = FakeWalletMiningService(workers: workers);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = WorkersController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, WorkersStatus.loaded);
      expect(controller.walletAddress, 'test-wallet');
      expect(controller.workers, same(workers));
      expect(service.lastWalletAddress, 'test-wallet');
      expect(service.loadWorkersCalls, 1);
      expect(controller.errorMessage, isNull);
    });

    test('changes status to noWallet when default wallet is missing', () async {
      final service = FakeWalletMiningService();

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: false),
      ]);

      final controller = WorkersController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, WorkersStatus.noWallet);
      expect(controller.walletAddress, isNull);
      expect(controller.workers, isEmpty);
      expect(controller.errorMessage, isNull);
      expect(service.loadWorkersCalls, 0);
    });

    test('changes status to error when service fails', () async {
      final service = FakeWalletMiningService(
        error: Exception('API unavailable'),
      );

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = WorkersController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, WorkersStatus.error);
      expect(controller.errorMessage, contains('API unavailable'));
      expect(controller.workers, isEmpty);
      expect(service.loadWorkersCalls, 1);
    });

    test('refresh loads workers again', () async {
      final workers = <Worker>[
        Worker(
          identifier: 'VIV',
          hashRate: 1929.78,
          hashRate2: 1929.77,
          totalHash: 8857800974.57,
          validShares: 106279,
          invalidShares: 86,
          lastSeen: DateTime(2026, 10, 3, 20, 0),
          status: WorkerStatus.online,
        ),
      ];

      final service = FakeWalletMiningService(workers: workers);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = WorkersController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(service.loadWorkersCalls, 1);

      await controller.refresh();

      expect(service.loadWorkersCalls, 2);
      expect(controller.status, WorkersStatus.loaded);
      expect(controller.workers, same(workers));
    });

    //(VIV [Worker Hashrate History Test — 2026-10-04])

    test('loads worker hashrate history', () async {
      final history = <WorkerHashrateHistory>[
        createTestWorkerHashratePoint(
          timestamp: DateTime(2026, 10, 4, 10, 0),
          hashRate: 1929.78,
          hashRate2: 1929.77,
        ),
        createTestWorkerHashratePoint(
          timestamp: DateTime(2026, 10, 4, 9, 0),
          hashRate: 1850.42,
          hashRate2: 1850.40,
        ),
      ];

      final service = FakeWalletMiningService(workerHashrateHistory: history);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = WorkersController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();
      await controller.loadWorkerHashrateHistory('VIV');

      expect(controller.workerHashrateHistory['VIV'], same(history));
      expect(service.lastWalletAddress, 'test-wallet');
      expect(service.lastWorkerIdentifier, 'VIV');
      expect(service.loadWorkerHashrateHistoryCalls, 1);
      expect(controller.loadingWorkerHistory, isEmpty);
      expect(controller.workerHistoryErrors, isEmpty);
    });

    test('does not load worker hashrate history twice', () async {
      final history = <WorkerHashrateHistory>[
        createTestWorkerHashratePoint(
          timestamp: DateTime(2026, 10, 4, 10, 0),
          hashRate: 1929.78,
          hashRate2: 1929.77,
        ),
      ];

      final service = FakeWalletMiningService(workerHashrateHistory: history);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = WorkersController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      await controller.loadWorkerHashrateHistory('VIV');
      await controller.loadWorkerHashrateHistory('VIV');

      expect(service.loadWorkerHashrateHistoryCalls, 1);
      expect(controller.workerHashrateHistory['VIV'], same(history));
    });

    test(
      'stores worker hashrate history error without changing workers status',
      () async {
        final service = FakeWalletMiningService(
          workerHashrateHistoryError: Exception('Worker history unavailable'),
        );

        final walletStorage = await prepareWalletStorage([
          createTestWallet(isDefault: true),
        ]);

        final controller = WorkersController(
          service: service,
          walletStorage: walletStorage,
        );

        await controller.loadDefaultWallet();

        expect(controller.status, WorkersStatus.loaded);

        await controller.loadWorkerHashrateHistory('VIV');

        expect(controller.status, WorkersStatus.loaded);
        expect(
          controller.workerHistoryErrors['VIV'],
          contains('Worker history unavailable'),
        );
        expect(controller.workerHashrateHistory, isEmpty);
        expect(controller.loadingWorkerHistory, isEmpty);
      },
    );

    test(
      'does not load worker history when default wallet is missing',
      () async {
        final service = FakeWalletMiningService();

        final walletStorage = await prepareWalletStorage([
          createTestWallet(isDefault: false),
        ]);

        final controller = WorkersController(
          service: service,
          walletStorage: walletStorage,
        );

        await controller.loadDefaultWallet();
        await controller.loadWorkerHashrateHistory('VIV');

        expect(service.loadWorkerHashrateHistoryCalls, 0);
        expect(controller.workerHashrateHistory, isEmpty);
        expect(controller.loadingWorkerHistory, isEmpty);
      },
    );

    test('clears worker history when refreshed', () async {
      final history = <WorkerHashrateHistory>[
        createTestWorkerHashratePoint(
          timestamp: DateTime(2026, 10, 4, 10, 0),
          hashRate: 1929.78,
          hashRate2: 1929.77,
        ),
      ];

      final service = FakeWalletMiningService(workerHashrateHistory: history);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = WorkersController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();
      await controller.loadWorkerHashrateHistory('VIV');

      expect(controller.workerHashrateHistory['VIV'], same(history));

      await controller.refresh();

      expect(controller.workerHashrateHistory, isEmpty);
      expect(controller.loadingWorkerHistory, isEmpty);
      expect(controller.workerHistoryErrors, isEmpty);
    });
  });
}
