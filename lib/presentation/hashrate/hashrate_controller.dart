//(VIV [Hashrate Controller — 2026-10-04])

import 'package:flutter/foundation.dart';

import '../../core/storage/wallet_storage.dart';
import '../../domain/entities/hashrate_history.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/services/wallet_mining_service_contract.dart';

//(VIV [Hashrate Status — 2026-10-04])

enum HashrateStatus { idle, loading, loaded, noWallet, error }

//(VIV [Hashrate Controller Class — 2026-10-04])

class HashrateController extends ChangeNotifier {
  HashrateController({required this.service, required this.walletStorage});

  final WalletMiningServiceContract service;
  final WalletStorage walletStorage;

  HashrateStatus status = HashrateStatus.idle;

  List<HashrateHistory> history = [];

  String? errorMessage;

  String? walletAddress;

  // Завантаження історії Hashrate основного гаманця.
  Future<void> loadDefaultWallet() async {
    status = HashrateStatus.loading;
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
        history = [];
        status = HashrateStatus.noWallet;
        notifyListeners();
        return;
      }

      walletAddress = defaultWallet.address;

      history = await service.loadHashrateHistory(defaultWallet.address);

      status = HashrateStatus.loaded;
      notifyListeners();
    } catch (error) {
      status = HashrateStatus.error;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadDefaultWallet();
  }
}
