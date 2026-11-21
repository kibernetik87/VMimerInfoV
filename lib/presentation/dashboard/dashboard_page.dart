//(VIV [Dashboard Page — 2026-11-03])

import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/wallet_stats.dart';
import '../../l10n/app_localizations.dart';
import 'dashboard_controller.dart';

//(VIV [Dashboard Page Class — 2026-11-03])

class DashboardPage extends StatefulWidget {
  const DashboardPage({required this.controller, super.key});

  final DashboardController controller;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

//(VIV [Dashboard Page State — 2026-11-03])

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onControllerChanged);

    // Автоматичне завантаження статистики
    // гаманця за замовчуванням.
    widget.controller.loadDefaultWallet();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadDefaultWallet() async {
    await widget.controller.loadDefaultWallet();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final localizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadDefaultWallet,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (controller.poolName != null) ...[
              Text(
                controller.poolName!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
            ],

            Text(
              localizations.dashboardSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            if (controller.status == DashboardStatus.loading)
              const _DashboardLoading(),

            if (controller.status == DashboardStatus.noWallet)
              _NoWalletCard(
                onAddWallet: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.addWalletToSeeMiningStats),
                    ),
                  );
                },
              ),

            if (controller.status == DashboardStatus.error)
              _DashboardError(
                message: controller.errorMessage ?? localizations.unknownError,
                onRetry: _loadDefaultWallet,
              ),

            if (controller.status == DashboardStatus.loaded &&
                controller.walletStats != null) ...[
              if (controller.walletAddress != null)
                _WalletAddressCard(address: controller.walletAddress!),

              const SizedBox(height: 12),

              //(VIV [Dashboard Miners Card — 2026-11-03])
              _MinersCard(
                total: controller.workersTotal,
                online: controller.workersOnline,
              ),

              const SizedBox(height: 12),

              _WalletStatsView(stats: controller.walletStats!),
            ],

            if (controller.status == DashboardStatus.idle)
              const _DashboardHint(),
          ],
        ),
      ),
    );
  }
}

//(VIV [Dashboard Loading — 2026-11-03])

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(localizations.loadingStatistics, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

//(VIV [No Wallet Card — 2026-11-03])

class _NoWalletCard extends StatelessWidget {
  const _NoWalletCard({required this.onAddWallet});

  final VoidCallback onAddWallet;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 52,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              localizations.noWallets,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.addWalletToSeeMiningStats,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAddWallet,
              icon: const Icon(Icons.account_balance_wallet),
              label: Text(localizations.goToWallets),
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Wallet Address Card — 2026-11-03])

class _WalletAddressCard extends StatelessWidget {
  const _WalletAddressCard({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final displayedAddress = address.length > 24
        ? '${address.substring(0, 12)}...'
              '${address.substring(address.length - 12)}'
        : address;

    return Card(
      child: ListTile(
        leading: Image.asset(
          'assets/icons/wallet.png',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        title: Text(AppLocalizations.of(context)!.defaultWallet),
        subtitle: Text(
          displayedAddress,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

//(VIV [Dashboard Miners Card — 2026-11-03])

class _MinersCard extends StatelessWidget {
  const _MinersCard({required this.total, required this.online});

  final int total;
  final int online;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final statusColor = online > 0 ? Colors.green : colorScheme.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/workers.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.miners,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$online / $total ${localizations.online}',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Icon(
              online > 0
                  ? Icons.check_circle_outline
                  : Icons.warning_amber_outlined,
              color: statusColor,
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Dashboard Error — 2026-11-03])

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(message)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(localizations.retry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Dashboard Hint — 2026-11-03])

class _DashboardHint extends StatelessWidget {
  const _DashboardHint();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.insights_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.statisticsLoadAutomatically,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Wallet Stats View — 2026-11-03])

class _WalletStatsView extends StatelessWidget {
  const _WalletStatsView({required this.stats});

  final WalletStats stats;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        _StatsCard(
          icon: Image.asset(
            'assets/icons/hashrate.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.hashrate,
          value: formatHashrate(stats.hashRate),
        ),
        const SizedBox(height: 10),

        _StatsCard(
          icon: Image.asset(
            'assets/icons/hashrate.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.hashrate2,
          value: formatHashrate(stats.hashRate2),
        ),
        const SizedBox(height: 10),

        _StatsCard(
          icon: Image.asset(
            'assets/icons/total_hashes.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.totalHashes,
          value: formatInteger(stats.totalHashes),
        ),
        const SizedBox(height: 10),

        _StatsCard(
          icon: Image.asset(
            'assets/icons/valid_shares.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.validShares,
          value: formatInteger(stats.validShares),
        ),
        const SizedBox(height: 10),

        _StatsCard(
          icon: Image.asset(
            'assets/icons/invalid_shares.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.invalidShares,
          value: formatInteger(stats.invalidShares),
        ),
        const SizedBox(height: 10),

        _StatsCard(
          icon: Image.asset(
            'assets/icons/payments.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.paid,
          value: '${stats.amountPaid.toStringAsFixed(9)} XMR',
        ),
        const SizedBox(height: 10),

        _StatsCard(
          icon: Image.asset(
            'assets/icons/wallet.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.due,
          value: '${stats.amountDue.toStringAsFixed(9)} XMR',
        ),
        const SizedBox(height: 10),

        _StatsCard(
          icon: Image.asset(
            'assets/icons/transactions.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: localizations.transactions,
          value: formatInteger(stats.transactionCount),
        ),
      ],
    );
  }
}

//(VIV [Stats Card — 2026-11-03])

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final Widget icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(width: 36, height: 36, child: Center(child: icon)),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
