
//(VIV [Workers Page — 2026-10-04])

import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/worker.dart';
import '../../domain/entities/worker_hashrate_history.dart';
import '../../l10n/app_localizations.dart';
import 'worker_hashrate_chart.dart';
import 'workers_controller.dart';

//(VIV [Workers Page Widget — 2026-10-04])

class WorkersPage extends StatefulWidget {
  const WorkersPage({required this.controller, super.key});

  final WorkersController controller;

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

//(VIV [Workers Page State — 2026-10-04])

class _WorkersPageState extends State<WorkersPage> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onControllerChanged);

    // Автоматичне завантаження Workers
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

  Future<void> _refreshWorkers() async {
    await widget.controller.refresh();
  }

  void _openWorkerDetails(Worker worker) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _WorkerDetailsPage(
          worker: worker,
          controller: widget.controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshWorkers,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (controller.status == WorkersStatus.loading)
              const _WorkersLoading(),
            if (controller.status == WorkersStatus.noWallet)
              const _WorkersNoWallet(),
            if (controller.status == WorkersStatus.error)
              _WorkersError(
                message:
                controller.errorMessage ??
                    AppLocalizations.of(context)!.unknownError,
                onRetry: _refreshWorkers,
              ),
            if (controller.status == WorkersStatus.loaded)
              _WorkersList(
                workers: controller.workers,
                onWorkerTap: _openWorkerDetails,
              ),
            if (controller.status == WorkersStatus.idle)
              const _WorkersHint(),
          ],
        ),
      ),
    );
  }
}

//(VIV [Workers Loading — 2026-10-04])

class _WorkersLoading extends StatelessWidget {
  const _WorkersLoading();

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
            Text(localizations.loadingWorkers, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

//(VIV [Workers No Wallet — 2026-10-04])

class _WorkersNoWallet extends StatelessWidget {
  const _WorkersNoWallet();

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
              localizations.noDefaultWallet,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.addAndSelectDefaultWallet,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Workers Error — 2026-10-04])

class _WorkersError extends StatelessWidget {
  const _WorkersError({
    required this.message,
    required this.onRetry,
  });

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

//(VIV [Workers Hint — 2026-10-04])

class _WorkersHint extends StatelessWidget {
  const _WorkersHint();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          localizations.workersLoadAutomatically,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//(VIV [Workers List — 2026-10-04])

class _WorkersList extends StatelessWidget {
  const _WorkersList({
    required this.workers,
    required this.onWorkerTap,
  });

  final List<Worker> workers;
  final ValueChanged<Worker> onWorkerTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (workers.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            localizations.workersNotFound,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final worker in workers) ...[
          _WorkerListTile(
            worker: worker,
            onTap: () => onWorkerTap(worker),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

//(VIV [Worker List Tile — 2026-11-15])

class _WorkerListTile extends StatelessWidget {
  const _WorkerListTile({
    required this.worker,
    required this.onTap,
  });

  final Worker worker;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _workerStatusColor(context, worker.status);
    final localizations = AppLocalizations.of(context)!;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Icon(
          Icons.memory,
          color: statusColor,
          size: 28,
        ),
        title: Text(
          worker.identifier,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${localizations.hashrate}: ${formatHashrate(worker.hashRate)}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WorkerStatusChip(status: worker.status),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

//(VIV [Worker Details Page — 2026-11-15])

class _WorkerDetailsPage extends StatelessWidget {
  const _WorkerDetailsPage({
    required this.worker,
    required this.controller,
  });

  final Worker worker;
  final WorkersController controller;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final statusColor = _workerStatusColor(context, worker.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          worker.identifier,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.memory,
                          color: statusColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            worker.identifier,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _WorkerStatusChip(status: worker.status),
                      ],
                    ),
                    const Divider(height: 28),
                    _WorkerValueRow(
                      title: localizations.hashrate,
                      value: formatHashrate(worker.hashRate),
                    ),
                    const SizedBox(height: 12),
                    _WorkerValueRow(
                      title: 'Hashrate²',
                      value: formatHashrate(worker.hashRate2),
                    ),
                    const SizedBox(height: 12),
                    _WorkerValueRow(
                      title: localizations.totalHashes,
                      value: formatInteger(worker.totalHash.toInt()),
                    ),
                    const SizedBox(height: 12),
                    _WorkerValueRow(
                      title: localizations.validShares,
                      value: formatInteger(worker.validShares),
                    ),
                    const SizedBox(height: 12),
                    _WorkerValueRow(
                      title: localizations.invalidShares,
                      value: formatInteger(worker.invalidShares),
                    ),
                    const SizedBox(height: 12),
                    _WorkerValueRow(
                      title: localizations.lastActivity,
                      value: _formatLastSeen(worker.lastSeen),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _WorkerHashrateHistorySection(
              worker: worker,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Worker Hashrate History Section — 2026-10-04])

class _WorkerHashrateHistorySection extends StatefulWidget {
  const _WorkerHashrateHistorySection({
    required this.worker,
    required this.controller,
  });

  final Worker worker;
  final WorkersController controller;

  @override
  State<_WorkerHashrateHistorySection> createState() =>
      _WorkerHashrateHistorySectionState();
}

//(VIV [Worker Hashrate History Section State — 2026-10-04])

class _WorkerHashrateHistorySectionState
    extends State<_WorkerHashrateHistorySection> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onControllerChanged);
    _loadHistory();
  }

  @override
  void didUpdateWidget(covariant _WorkerHashrateHistorySection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }

    if (oldWidget.worker.identifier != widget.worker.identifier) {
      _loadHistory();
    }
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

  Future<void> _loadHistory() async {
    await widget.controller.loadWorkerHashrateHistory(
      widget.worker.identifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final identifier = widget.worker.identifier;

    final isLoading = widget.controller.loadingWorkerHistory.contains(
      identifier,
    );

    final error = widget.controller.workerHistoryErrors[identifier];

    final history = widget.controller.workerHashrateHistory[identifier];

    return _WorkerHashrateHistoryContent(
      history: history,
      isLoading: isLoading,
      error: error,
      onRetry: _loadHistory,
    );
  }
}

//(VIV [Worker Hashrate History Content — 2026-10-04])

class _WorkerHashrateHistoryContent extends StatelessWidget {
  const _WorkerHashrateHistoryContent({
    required this.history,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  final List<WorkerHashrateHistory>? history;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (isLoading && history == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(localizations.loadingHistory)),
            ],
          ),
        ),
      );
    }

    if (error != null && history == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                size: 20,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  localizations.failedToLoadHistory,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              IconButton(
                onPressed: onRetry,
                tooltip: localizations.retry,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      );
    }

    if (history == null) {
      return const SizedBox.shrink();
    }

    if (history!.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(localizations.workerHashrateHistoryEmpty),
        ),
      );
    }

    //(VIV [Worker Hashrate Chart Integration — 2026-10-04])

    return WorkerHashrateChart(history: history!);
  }
}

//(VIV [Worker Status Chip — 2026-10-04])

class _WorkerStatusChip extends StatelessWidget {
  const _WorkerStatusChip({required this.status});

  final WorkerStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _workerStatusColor(context, status);

    return Chip(
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(
        _workerStatusText(context, status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
      side: BorderSide(color: color),
      padding: EdgeInsets.zero,
    );
  }
}

//(VIV [Worker Value Row — 2026-10-04])

class _WorkerValueRow extends StatelessWidget {
  const _WorkerValueRow({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

//(VIV [Worker Status Color — 2026-10-04])

Color _workerStatusColor(BuildContext context, WorkerStatus status) {
  switch (status) {
    case WorkerStatus.online:
      return Theme.of(context).colorScheme.primary;
    case WorkerStatus.zeroHashrate:
      return Theme.of(context).colorScheme.tertiary;
    case WorkerStatus.offline:
      return Theme.of(context).colorScheme.error;
  }
}

//(VIV [Worker Status Text — 2026-10-04])

String _workerStatusText(BuildContext context, WorkerStatus status) {
  final localizations = AppLocalizations.of(context)!;

  switch (status) {
    case WorkerStatus.online:
      return localizations.online;
    case WorkerStatus.zeroHashrate:
      return localizations.workerZeroHashrate;
    case WorkerStatus.offline:
      return localizations.workerOffline;
  }
}

//(VIV [Worker Last Seen Formatter — 2026-10-04])

String _formatLastSeen(DateTime value) {
  final localValue = value.toLocal();

  final day = localValue.day.toString().padLeft(2, '0');
  final month = localValue.month.toString().padLeft(2, '0');
  final hour = localValue.hour.toString().padLeft(2, '0');
  final minute = localValue.minute.toString().padLeft(2, '0');

  return '$day.$month $hour:$minute';
}
