//(VIV [Workers Controller — 2026-10-04])

import 'package:flutter/foundation.dart';

import '../../core/storage/wallet_storage.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/entities/worker.dart';
import '../../domain/entities/worker_hashrate_history.dart';
import '../../domain/services/wallet_mining_service_contract.dart';

//(VIV [Workers Status — 2026-10-03])

enum WorkersStatus { idle, loading, loaded, noWallet, error }

//(VIV [Workers Controller Class — 2026-10-04])

class WorkersController extends ChangeNotifier {
  WorkersController({required this.service, required this.walletStorage});

  final WalletMiningServiceContract service;
  final WalletStorage walletStorage;

  WorkersStatus status = WorkersStatus.idle;

  List<Worker> workers = [];

  String? errorMessage;

  String? walletAddress;

  //(VIV [Worker Hashrate History State — 2026-10-04])

  final Map<String, List<WorkerHashrateHistory>> workerHashrateHistory = {};

  final Set<String> loadingWorkerHistory = {};

  final Map<String, String> workerHistoryErrors = {};

  // Завантаження Workers основного гаманця.
  Future<void> loadDefaultWallet() async {
    status = WorkersStatus.loading;
    errorMessage = null;
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
        workers = [];
        workerHashrateHistory.clear();
        loadingWorkerHistory.clear();
        workerHistoryErrors.clear();
        status = WorkersStatus.noWallet;
        notifyListeners();
        return;
      }

      walletAddress = defaultWallet.address;

      workers = await service.loadWorkers(defaultWallet.address);

      workerHashrateHistory.clear();
      loadingWorkerHistory.clear();
      workerHistoryErrors.clear();

      status = WorkersStatus.loaded;
      notifyListeners();
    } catch (error) {
      status = WorkersStatus.error;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  //(VIV [Load Worker Hashrate History — 2026-10-04])

  Future<void> loadWorkerHashrateHistory(String workerIdentifier) async {
    final address = walletAddress;

    if (address == null || address.isEmpty) {
      return;
    }

    if (workerHashrateHistory.containsKey(workerIdentifier)) {
      return;
    }

    if (loadingWorkerHistory.contains(workerIdentifier)) {
      return;
    }

    loadingWorkerHistory.add(workerIdentifier);
    workerHistoryErrors.remove(workerIdentifier);
    notifyListeners();

    try {
      final history = await service.loadWorkerHashrateHistory(
        address,
        workerIdentifier,
      );

      workerHashrateHistory[workerIdentifier] = history;
    } catch (error) {
      workerHistoryErrors[workerIdentifier] = error.toString();
    } finally {
      loadingWorkerHistory.remove(workerIdentifier);
      notifyListeners();
    }
  }

  // Оновлення списку Workers.
  Future<void> refresh() async {
    await loadDefaultWallet();
  }
}
