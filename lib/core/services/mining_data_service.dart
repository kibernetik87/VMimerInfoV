//(VIV [Mining Data Service — 2026-10-05])

import '../models/wallet_mining_snapshot.dart';
import '../models/widget_refresh_data.dart';
import '../../domain/entities/worker.dart';
import '../../domain/services/wallet_mining_service_contract.dart';
import '../storage/wallet_mining_snapshot_cache.dart';
import '../storage/widget_refresh_cache.dart';

//(VIV [Mining Data Service Class — 2026-10-05])
class MiningDataService {
  MiningDataService({
    required this.walletMiningService,
    required this.snapshotCache,
    required this.widgetRefreshCache,
  });

  final WalletMiningServiceContract walletMiningService;
  final WalletMiningSnapshotCache snapshotCache;
  final WidgetRefreshCache widgetRefreshCache;

  //(VIV [Refresh Wallet Snapshot — 2026-10-05])
  Future<WalletMiningSnapshot> refresh(
    String walletId,
    String walletAddress,
  ) async {
    final walletStats = await walletMiningService.loadWalletStats(
      walletAddress,
    );

    //(VIV [Load Workers Through Service Contract — 2026-10-05])
    final workers = await walletMiningService.loadWorkers(walletAddress);
    //) VIV [Load Workers Through Service Contract — 2026-10-05]
    //(VIV [Calculate Workers Status — 2026-10-05])
    final workersTotal = workers.length;

    final workersOnline = workers
        .where((worker) => worker.status == WorkerStatus.online)
        .length;
    //) VIV [Calculate Workers Status — 2026-10-05]
    final snapshot = WalletMiningSnapshot(
      walletId: walletId,
      walletAddress: walletAddress,
      hashRate: walletStats.hashRate,
      hashRate2: walletStats.hashRate2,
      workersOnline: workersOnline,
      workersTotal: workersTotal,
      amountPaid: walletStats.amountPaid,
      amountDue: walletStats.amountDue,
      updatedAt: DateTime.now(),
    );

    await snapshotCache.save(snapshot);

    //(VIV [Save Widget Refresh Data — 2026-10-05])
    await widgetRefreshCache.save(
      WidgetRefreshData(
        walletId: snapshot.walletId,
        walletAddress: snapshot.walletAddress,
        hashRate: snapshot.hashRate,
        hashRate2: snapshot.hashRate2,
        workersOnline: snapshot.workersOnline,
        workersTotal: snapshot.workersTotal,
        amountPaid: snapshot.amountPaid,
        amountDue: snapshot.amountDue,
        updatedAt: snapshot.updatedAt,
      ),
    );
    //) VIV [Save Widget Refresh Data — 2026-10-05]

    return snapshot;
  }
  //) VIV [Refresh Wallet Snapshot — 2026-10-05]

  //(VIV [Load Cached Snapshot — 2026-10-05])
  Future<WalletMiningSnapshot?> loadCached(String walletId) async {
    return snapshotCache.load(walletId);
  }
  //) VIV [Load Cached Snapshot — 2026-10-05]

  //(VIV [Remove Cached Snapshot — 2026-10-05])
  Future<void> removeCached(String walletId) async {
    await snapshotCache.remove(walletId);
  }
  //) VIV [Remove Cached Snapshot — 2026-10-05]
}
//) VIV [Mining Data Service Class — 2026-10-05]

//) VIV [Mining Data Service — 2026-10-05]
