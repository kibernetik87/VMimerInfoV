//(VIV [Dashboard Controller — 2026-10-12])

import 'package:flutter/foundation.dart';

import '../../core/storage/wallet_storage.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/entities/wallet_stats.dart';
import '../../domain/entities/worker.dart';
import '../../domain/services/wallet_mining_service_contract.dart';
import '../../core/services/widget_service.dart';
import '../../core/services/mining_data_service.dart';

//(VIV [Dashboard Status — 2026-10-12])

enum DashboardStatus { idle, loading, loaded, noWallet, error }

//) VIV [Dashboard Status — 2026-10-12]

//(VIV [Dashboard Controller Class — 2026-10-12])

class DashboardController extends ChangeNotifier {
  DashboardController({
    required this.service,
    required this.walletStorage,
    required this.poolNameFor,
    this.miningDataService,
  });

  final WalletMiningServiceContract service;
  final WalletStorage walletStorage;
  final MiningDataService? miningDataService;

  // Назва пулу визначається за poolId гаманця.
  final String? Function(String poolId) poolNameFor;

  //(VIV [Dashboard Widget Service — 2026-10-12])

  final WidgetService widgetService = WidgetService();

  //) VIV [Dashboard Widget Service — 2026-10-12]

  DashboardStatus status = DashboardStatus.idle;
  WalletStats? walletStats;
  String? errorMessage;
  String? walletAddress;
  String? poolName;

  //(VIV [Dashboard Workers Count — 2026-10-12])

  int workersTotal = 0;
  int workersOnline = 0;

  //) VIV [Dashboard Workers Count — 2026-10-12]

  //(VIV [Load Default Wallet — 2026-10-12])

  Future<void> loadDefaultWallet() async {
    status = DashboardStatus.loading;
    errorMessage = null;
    poolName = null;
    notifyListeners();

    try {
      final wallets = await walletStorage.loadWallets();

      Wallet? defaultWallet;

      for (final wallet in wallets) {
        if (wallet.isDefault) {
          defaultWallet = wallet;
          break;
        }
      }

      if (defaultWallet == null) {
        walletAddress = null;
        walletStats = null;
        workersTotal = 0;
        workersOnline = 0;
        poolName = null;
        status = DashboardStatus.noWallet;
        notifyListeners();
        return;
      }

      walletAddress = defaultWallet.address;
      poolName = poolNameFor(defaultWallet.poolId);

      //(VIV [Dashboard Default Wallet Data Loading — 2026-10-12])

      final results = await Future.wait([
        service.loadWalletStats(defaultWallet.address),
        service.loadWorkers(defaultWallet.address),
      ]);

      walletStats = results[0] as WalletStats;

      final defaultWorkers = results[1] as List<Worker>;

      workersTotal = defaultWorkers.length;
      workersOnline = defaultWorkers
          .where((worker) => worker.status == WorkerStatus.online)
          .length;

      //) VIV [Dashboard Default Wallet Data Loading — 2026-10-12]

      //(VIV [Dashboard Mining Data Service Refresh — 2026-10-12])

      await miningDataService?.refresh(defaultWallet.id, defaultWallet.address);

      //) VIV [Dashboard Mining Data Service Refresh — 2026-10-12]

      //(VIV [Update Android Widget — 2026-10-12])

      await widgetService.updateWidgetData(
        hashRate: walletStats!.hashRate,
        hashRate2: walletStats!.hashRate2,
        workersOnline: workersOnline,
        workersTotal: workersTotal,
        amountPaid: walletStats!.amountPaid,
        amountDue: walletStats!.amountDue,
        updatedAt: DateTime.now(),
      );

      //) VIV [Update Android Widget — 2026-10-12]

      status = DashboardStatus.loaded;
      notifyListeners();
    } catch (error) {
      poolName = null;
      status = DashboardStatus.error;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  //) VIV [Load Default Wallet — 2026-10-12]

  //(VIV [Legacy Manual Wallet Loading — 2026-10-12])

  // Тимчасова сумісність зі старим Dashboard.
  // Після переходу Dashboard на основний гаманець
  // цей метод буде видалено разом із ручним введенням адреси.
  Future<void> loadWallet(String walletAddress) async {
    status = DashboardStatus.loading;
    errorMessage = null;
    poolName = null;
    notifyListeners();

    try {
      this.walletAddress = walletAddress;

      final results = await Future.wait([
        service.loadWalletStats(walletAddress),
        service.loadWorkers(walletAddress),
      ]);

      walletStats = results[0] as WalletStats;

      final workers = results[1] as List<Worker>;

      workersTotal = workers.length;
      workersOnline = workers
          .where((worker) => worker.status == WorkerStatus.online)
          .length;

      status = DashboardStatus.loaded;
      notifyListeners();
    } catch (error) {
      status = DashboardStatus.error;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  //) VIV [Legacy Manual Wallet Loading — 2026-10-12]
}

//) VIV [Dashboard Controller Class — 2026-10-12]

//) VIV [Dashboard Controller — 2026-10-12]
