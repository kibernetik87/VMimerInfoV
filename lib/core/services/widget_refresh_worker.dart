//(VIV [Widget Refresh Worker — 2026-10-06])

import '../app_dependencies.dart';
import '../models/wallet_mining_snapshot.dart';

//(VIV [Widget Refresh Worker Class — 2026-10-06])

class WidgetRefreshWorker {
  WidgetRefreshWorker({required this.dependencies});

  final AppDependencies dependencies;

  //(VIV [Refresh Wallet — 2026-10-06])

  Future<WalletMiningSnapshot?> refreshWallet(String walletId) async {
    final wallets = await dependencies.walletStorage.loadWallets();

    final walletIndex = wallets.indexWhere((wallet) => wallet.id == walletId);

    if (walletIndex == -1) {
      return null;
    }

    final wallet = wallets[walletIndex];

    //(VIV [Refresh Through Mining Data Service — 2026-10-06])

    final snapshot = await dependencies.miningDataService.refresh(
      wallet.id,
      wallet.address,
    );

    //) VIV [Refresh Through Mining Data Service — 2026-10-06]

    return snapshot;
  }

  //) VIV [Refresh Wallet — 2026-10-06]
}

//) VIV [Widget Refresh Worker Class — 2026-10-06]

//) VIV [Widget Refresh Worker — 2026-10-06]
