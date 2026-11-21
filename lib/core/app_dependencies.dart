//(VIV [App Dependencies — 2026-10-04])

import '../core/storage/locale_storage.dart';
import '../core/storage/notification_event_storage.dart';
import '../core/storage/notification_storage.dart';
import '../core/storage/theme_storage.dart';
import '../core/storage/wallet_storage.dart';
import '../data/datasources/moneroocean/moneroocean_adapter.dart';
import '../data/datasources/moneroocean/moneroocean_api_client.dart';
import '../data/repositories/moneroocean_repository.dart';
import '../domain/entities/wallet.dart';
import '../domain/services/wallet_mining_service.dart';
import 'services/mining_data_service.dart';
import 'storage/wallet_mining_snapshot_cache.dart';
import 'storage/widget_refresh_cache.dart';

//(VIV [App Dependencies Class — 2026-10-04])

class AppDependencies {
  AppDependencies() {
    apiClient = MoneroOceanApiClient();
    adapter = MoneroOceanAdapter(apiClient: apiClient);
    repository = MoneroOceanRepository(adapter: adapter);
    walletMiningService = WalletMiningService(repository: repository);

    //(VIV [Mining Data Service Initialization — 2026-10-05])

    miningDataService = MiningDataService(
      walletMiningService: walletMiningService,
      snapshotCache: WalletMiningSnapshotCache(),
      widgetRefreshCache: WidgetRefreshCache(),
    );

    //) VIV [Mining Data Service Initialization — 2026-10-05]

    walletStorage = WalletStorage();

    //(VIV [Locale Storage Initialization — 2026-10-04])

    localeStorage = LocaleStorage();

    //(VIV [Theme Storage Initialization — 2026-11-08])

    themeStorage = ThemeStorage();

    //(VIV [Notification Storage Initialization — 2026-10-04])

    notificationStorage = NotificationStorage();

    //(VIV [Notification Event Storage Initialization — 2026-10-04])

    notificationEventStorage = NotificationEventStorage();
  }

  late final MoneroOceanApiClient apiClient;
  late final MoneroOceanAdapter adapter;
  late final MoneroOceanRepository repository;
  late final WalletMiningService walletMiningService;
  late final WalletStorage walletStorage;

  //(VIV [Locale Storage Dependency — 2026-10-04])

  late final LocaleStorage localeStorage;

  //(VIV [Theme Storage Dependency — 2026-11-08])

  late final ThemeStorage themeStorage;

  //(VIV [Notification Storage Dependency — 2026-10-04])

  late final NotificationStorage notificationStorage;

  //(VIV [Notification Event Storage Dependency — 2026-10-04])

  late final NotificationEventStorage notificationEventStorage;

  late final MiningDataService miningDataService;

  //(VIV [Pool Name Resolver — 2026-11-14])

  String? poolNameFor(String poolId) {
    if (poolId == Wallet.defaultPoolId) {
      return adapter.poolName;
    }

    return null;
  }

  //) VIV [Pool Name Resolver — 2026-11-14]

  void dispose() {
    apiClient.dispose();
  }
}

//) VIV [App Dependencies Class — 2026-10-04]

//) VIV [App Dependencies — 2026-10-04]
