//(VIV [Payments Controller Test — 2026-10-04])

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
import 'package:vmimerinfov/presentation/payments/payments_controller.dart';

//(VIV [Fake Wallet Mining Service — 2026-10-04])

class FakeWalletMiningService implements WalletMiningServiceContract {
  FakeWalletMiningService({this.payments = const <Payment>[], this.error});

  final List<Payment> payments;
  final Object? error;

  String? lastWalletAddress;
  int loadPaymentsCalls = 0;

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
  }) async {
    lastWalletAddress = walletAddress;
    loadPaymentsCalls++;

    if (error != null) {
      throw error!;
    }

    return payments;
  }

  //(VIV [Fake Load Hashrate History — 2026-10-04])

  @override
  Future<List<HashrateHistory>> loadHashrateHistory(String walletAddress) {
    return Future.value(<HashrateHistory>[]);
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
  group('PaymentsController', () {
    test('loads payments from default wallet', () async {
      final payments = <Payment>[
        Payment(
          type: 'pplns',
          timestamp: DateTime(2026, 10, 4, 12, 30),
          amount: 10.241764674,
          txnHash: 'a8a21d368206ce0725c908323857238940fc5bd3c9c5a776c4464cf534f93568',
          mixin: 15,
        ),
        Payment(
          type: 'pplns',
          timestamp: DateTime(2026, 9, 27, 10, 20),
          amount: 10.001740656,
          txnHash: '9439ba376b4128cd1cab430be0a01dc643e78656539487edf3c286c2b7423f99',
          mixin: 15,
        ),
      ];

      final service = FakeWalletMiningService(payments: payments);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = PaymentsController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, PaymentsStatus.loaded);
      expect(controller.walletAddress, 'test-wallet');
      expect(controller.payments, same(payments));
      expect(service.lastWalletAddress, 'test-wallet');
      expect(service.loadPaymentsCalls, 1);
      expect(controller.errorMessage, isNull);
    });

    test('changes status to noWallet when default wallet is missing', () async {
      final service = FakeWalletMiningService();

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: false),
      ]);

      final controller = PaymentsController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, PaymentsStatus.noWallet);
      expect(controller.walletAddress, isNull);
      expect(controller.payments, isEmpty);
      expect(controller.errorMessage, isNull);
      expect(service.loadPaymentsCalls, 0);
    });

    test('changes status to error when service fails', () async {
      final service = FakeWalletMiningService(
        error: Exception('API unavailable'),
      );

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = PaymentsController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(controller.status, PaymentsStatus.error);
      expect(controller.errorMessage, contains('API unavailable'));
      expect(controller.payments, isEmpty);
      expect(service.loadPaymentsCalls, 1);
    });

    test('refresh loads payments again', () async {
      final payments = <Payment>[
        Payment(
          type: 'pplns',
          timestamp: DateTime(2026, 10, 4, 12, 30),
          amount: 2.705010508,
          txnHash: '618a84be5b0b2cb29d56d4a3e2f126faec486006d02ebd1afe3404f3f06d91a0',
          mixin: 15,
        ),
      ];

      final service = FakeWalletMiningService(payments: payments);

      final walletStorage = await prepareWalletStorage([
        createTestWallet(isDefault: true),
      ]);

      final controller = PaymentsController(
        service: service,
        walletStorage: walletStorage,
      );

      await controller.loadDefaultWallet();

      expect(service.loadPaymentsCalls, 1);

      await controller.refresh();

      expect(service.loadPaymentsCalls, 2);
      expect(controller.status, PaymentsStatus.loaded);
      expect(controller.payments, same(payments));
    });
  });
}
