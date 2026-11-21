//(VIV [Hashrate Page — 2026-10-04])

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/hashrate_history.dart';
import '../../l10n/app_localizations.dart';
import 'hashrate_controller.dart';

//(VIV [Hashrate Series — 2026-10-04])

enum _HashrateSeries { hashRate, hashRate2, both }

//(VIV [Hashrate Period — 2026-10-04])

enum _HashratePeriod { hour1, hour3, hour6, hour12, hour24, all }

//(VIV [Hashrate Page Class — 2026-10-04])

class HashratePage extends StatefulWidget {
  const HashratePage({required this.controller, super.key});

  final HashrateController controller;

  @override
  State<HashratePage> createState() => _HashratePageState();
}

//(VIV [Hashrate Page State — 2026-10-04])

class _HashratePageState extends State<HashratePage> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onControllerChanged);

    if (widget.controller.status == HashrateStatus.idle) {
      widget.controller.loadDefaultWallet();
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

  Future<void> _refresh() async {
    await widget.controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    switch (controller.status) {
      case HashrateStatus.idle:
      case HashrateStatus.loading:
        return const _HashrateLoading();

      case HashrateStatus.noWallet:
        return const _HashrateNoWallet();

      case HashrateStatus.error:
        return _HashrateError(
          message: controller.errorMessage,
          onRetry: _refresh,
        );

      case HashrateStatus.loaded:
        if (controller.history.isEmpty) {
          return _HashrateEmpty(onRefresh: _refresh);
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: _HashrateContent(history: controller.history),
        );
    }
  }
}

//(VIV [Hashrate Loading — 2026-10-04])

class _HashrateLoading extends StatelessWidget {
  const _HashrateLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

//(VIV [Hashrate No Wallet — 2026-10-04])

class _HashrateNoWallet extends StatelessWidget {
  const _HashrateNoWallet();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '${localizations.noMainWallet}\n'
          '${localizations.addWalletInWalletsSection}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//(VIV [Hashrate Error — 2026-10-04])

class _HashrateError extends StatelessWidget {
  const _HashrateError({required this.message, required this.onRetry});

  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              localizations.failedToLoadHashrateHistory,
              textAlign: TextAlign.center,
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(message!, textAlign: TextAlign.left),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.retry),
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Hashrate Empty — 2026-10-04])

class _HashrateEmpty extends StatelessWidget {
  const _HashrateEmpty({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.show_chart, size: 48),
            const SizedBox(height: 16),
            Text(
              localizations.hashrateHistoryEmpty,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.refresh),
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Hashrate Content — 2026-10-04])

class _HashrateContent extends StatelessWidget {
  const _HashrateContent({required this.history});

  final List<HashrateHistory> history;

  @override
  Widget build(BuildContext context) {
    final latest = _latestPoint(history);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _HashrateSummaryCard(
          hashRate: latest.hashRate,
          hashRate2: latest.hashRate2,
        ),
        const SizedBox(height: 16),
        _HashrateChartCard(history: history),
      ],
    );
  }

  //(VIV [Latest Hashrate Point — 2026-10-04])

  HashrateHistory _latestPoint(List<HashrateHistory> history) {
    var latest = history.first;

    for (final point in history.skip(1)) {
      if (point.timestamp.isAfter(latest.timestamp)) {
        latest = point;
      }
    }

    return latest;
  }
}

//(VIV [Hashrate Summary Card — 2026-10-04])

class _HashrateSummaryCard extends StatelessWidget {
  const _HashrateSummaryCard({required this.hashRate, required this.hashRate2});

  final double hashRate;
  final double hashRate2;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.currentHashrate,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _HashrateValue(
                    title: 'Hashrate',
                    value: formatHashrate(hashRate),
                    icon: Icons.speed,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _HashrateValue(
                    title: 'Hashrate2',
                    value: formatHashrate(hashRate2),
                    icon: Icons.bolt,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Hashrate Value — 2026-10-04])

class _HashrateValue extends StatelessWidget {
  const _HashrateValue({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

//(VIV [Hashrate Chart Card — 2026-10-04])

class _HashrateChartCard extends StatefulWidget {
  const _HashrateChartCard({required this.history});

  final List<HashrateHistory> history;

  @override
  State<_HashrateChartCard> createState() => _HashrateChartCardState();
}

//(VIV [Hashrate Chart Card State — 2026-10-04])

class _HashrateChartCardState extends State<_HashrateChartCard> {
  _HashrateSeries _series = _HashrateSeries.both;

  _HashratePeriod _period = _HashratePeriod.hour1;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final filteredHistory = _filterHistory(widget.history, _period);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      localizations.hashrateHistory,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),

                //(VIV [Fullscreen Hashrate Button — 2026-10-04])
                IconButton(
                  tooltip: localizations.expandChart,
                  onPressed: filteredHistory.isEmpty
                      ? null
                      : () {
                          _openFullscreenChart(context, filteredHistory);
                        },
                  icon: const Icon(Icons.fullscreen),
                ),
              ],
            ),
            const SizedBox(height: 12),

            //(VIV [Hashrate Series Selector — 2026-10-04])
            _HashrateSeriesSelector(
              value: _series,
              onChanged: (value) {
                setState(() {
                  _series = value;
                });
              },
            ),

            const SizedBox(height: 12),

            //(VIV [Hashrate Period Selector — 2026-10-04])
            _HashratePeriodSelector(
              value: _period,
              onChanged: (value) {
                setState(() {
                  _period = value;
                });
              },
            ),

            const SizedBox(height: 16),

            if (filteredHistory.isEmpty)
              SizedBox(
                height: 330,
                child: Center(
                  child: Text(
                    localizations.noDataForSelectedPeriod,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              SizedBox(
                height: 330,
                child: LineChart(
                  _buildChartData(
                    context,
                    history: filteredHistory,
                    compact: true,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  //(VIV [Open Landscape Hashrate Chart — 2026-10-04])

  void _openFullscreenChart(
    BuildContext context,
    List<HashrateHistory> filteredHistory,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) {
              return _LandscapeHashratePage(
                history: filteredHistory,
                series: _series,
                period: _period,
              );
            },
          ),
        )
        .then((_) {
          //(VIV [Restore Portrait Orientation — 2026-10-04])
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        });
  }

  Widget _buildLegend(BuildContext context) {
    final items = <Widget>[];

    if (_series == _HashrateSeries.hashRate ||
        _series == _HashrateSeries.both) {
      items.add(
        const _ChartLegendItem(label: 'Hashrate', icon: Icons.show_chart),
      );
    }

    if (_series == _HashrateSeries.both) {
      items.add(const SizedBox(width: 24));
    }

    if (_series == _HashrateSeries.hashRate2 ||
        _series == _HashrateSeries.both) {
      items.add(
        const _ChartLegendItem(label: 'Hashrate2', icon: Icons.timeline),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: items);
  }

  LineChartData _buildChartData(
    BuildContext context, {
    required List<HashrateHistory> history,
    required bool compact,
  }) {
    final chartScale = _calculateChartScale(history);

    final spots1 = <FlSpot>[];
    final spots2 = <FlSpot>[];

    for (var index = 0; index < history.length; index++) {
      final point = history[index];

      if (_series == _HashrateSeries.hashRate ||
          _series == _HashrateSeries.both) {
        spots1.add(FlSpot(index.toDouble(), point.hashRate));
      }

      if (_series == _HashrateSeries.hashRate2 ||
          _series == _HashrateSeries.both) {
        spots2.add(FlSpot(index.toDouble(), point.hashRate2));
      }
    }

    final bottomInterval = _bottomTitleInterval(
      history: history,
      compact: compact,
    );

    final lineBars = <LineChartBarData>[];

    if (_series == _HashrateSeries.hashRate ||
        _series == _HashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots1,
          isCurved: true,

          //(VIV [Thin Hashrate Line — 2026-10-04])
          barWidth: 1,

          dotData: const FlDotData(show: false),
        ),
      );
    }

    if (_series == _HashrateSeries.hashRate2 ||
        _series == _HashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots2,
          isCurved: true,

          //(VIV [Thin Hashrate2 Line — 2026-10-04])
          barWidth: 1.5,

          dotData: const FlDotData(show: false),
        ),
      );
    }

    return LineChartData(
      minY: chartScale.minY,
      maxY: chartScale.maxY,
      minX: 0,
      maxX: history.length > 1 ? (history.length - 1).toDouble() : 1,

      //(VIV [Cleaner Hashrate Grid — 2026-10-04])
      gridData: FlGridData(
        show: true,
        horizontalInterval: chartScale.interval,
        verticalInterval: bottomInterval,
        drawVerticalLine: false,
      ),

      borderData: FlBorderData(show: true),

      //(VIV [Hashrate Chart Titles — 2026-10-04])
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 64,
            interval: chartScale.interval,
            getTitlesWidget: (value, meta) {
              return Text(
                formatHashrate(value),
                style: Theme.of(context).textTheme.bodySmall,
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: compact ? 30 : 36,
            interval: bottomInterval,
            getTitlesWidget: (value, meta) {
              final index = value.round();

              if (index < 0 || index >= history.length) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                child: Text(
                  _formatTime(history[index].timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ),
      ),

      //(VIV [Hashrate Touch Tooltip — 2026-10-04])
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.round();

              if (index < 0 || index >= history.length) {
                return null;
              }

              final point = history[index];

              final title = _tooltipTitle(spot);

              return LineTooltipItem(
                '${_formatTime(point.timestamp)}\n'
                '$title: ${formatHashrate(spot.y)}',
                Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
              );
            }).toList();
          },
        ),
      ),

      lineBarsData: lineBars,
    );
  }

  String _tooltipTitle(LineBarSpot spot) {
    if (_series == _HashrateSeries.both) {
      return spot.barIndex == 0 ? 'Hashrate' : 'Hashrate2';
    }

    if (_series == _HashrateSeries.hashRate) {
      return 'Hashrate';
    }

    return 'Hashrate2';
  }

  //(VIV [Hashrate History Filter — 2026-10-04])

  List<HashrateHistory> _filterHistory(
    List<HashrateHistory> source,
    _HashratePeriod period,
  ) {
    if (source.isEmpty) {
      return const [];
    }

    final sorted = List<HashrateHistory>.from(source)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (period == _HashratePeriod.all) {
      return sorted;
    }

    final latest = sorted.last;

    final duration = switch (period) {
      _HashratePeriod.hour1 => const Duration(hours: 1),
      _HashratePeriod.hour3 => const Duration(hours: 3),
      _HashratePeriod.hour6 => const Duration(hours: 6),
      _HashratePeriod.hour12 => const Duration(hours: 12),
      _HashratePeriod.hour24 => const Duration(hours: 24),
      _HashratePeriod.all => Duration.zero,
    };

    final cutoff = latest.timestamp.subtract(duration);

    return sorted.where((point) => !point.timestamp.isBefore(cutoff)).toList();
  }

  //(VIV [Dynamic Hashrate Chart Scale — 2026-10-04])

  _ChartScale _calculateChartScale(List<HashrateHistory> history) {
    var minValue = double.infinity;
    var maxValue = double.negativeInfinity;

    for (final point in history) {
      if (_series == _HashrateSeries.hashRate ||
          _series == _HashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate);

        maxValue = math.max(maxValue, point.hashRate);
      }

      if (_series == _HashrateSeries.hashRate2 ||
          _series == _HashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate2);

        maxValue = math.max(maxValue, point.hashRate2);
      }
    }

    if (!minValue.isFinite || !maxValue.isFinite) {
      return const _ChartScale(minY: 0, maxY: 1, interval: 0.2);
    }

    final range = maxValue - minValue;

    if (range <= 0) {
      final padding = math.max(maxValue.abs() * 0.05, 1);

      return _ChartScale(
        minY: maxValue - padding,
        maxY: maxValue + padding,
        interval: padding / 2,
      );
    }

    final padding = range * 0.10;

    var minY = minValue - padding;
    var maxY = maxValue + padding;

    final expandedRange = maxY - minY;

    final rawInterval = expandedRange / 5;
    final interval = _niceInterval(rawInterval);

    minY = (minY / interval).floor() * interval;
    maxY = (maxY / interval).ceil() * interval;

    return _ChartScale(minY: minY, maxY: maxY, interval: interval);
  }

  //(VIV [Nice Hashrate Chart Interval — 2026-10-04])

  double _niceInterval(double value) {
    if (value <= 0 || !value.isFinite) {
      return 1;
    }

    final magnitude = math
        .pow(10, (math.log(value) / math.ln10).floor())
        .toDouble();

    final normalized = value / magnitude;

    double niceNormalized;

    if (normalized <= 1) {
      niceNormalized = 1;
    } else if (normalized <= 2) {
      niceNormalized = 2;
    } else if (normalized <= 5) {
      niceNormalized = 5;
    } else {
      niceNormalized = 10;
    }

    return niceNormalized * magnitude;
  }

  //(VIV [Compact X Axis — 2026-10-04])

  double _bottomTitleInterval({
    required List<HashrateHistory> history,
    required bool compact,
  }) {
    if (history.length <= 1) {
      return 1;
    }

    final targetLabels = compact ? 5 : 8;

    if (history.length <= targetLabels) {
      return 1;
    }

    return ((history.length - 1) / (targetLabels - 1)).ceilToDouble();
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

//(VIV [Hashrate Series Selector — 2026-10-04])

class _HashrateSeriesSelector extends StatelessWidget {
  const _HashrateSeriesSelector({required this.value, required this.onChanged});

  final _HashrateSeries value;

  final ValueChanged<_HashrateSeries> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<_HashrateSeries>(
        segments: [
          const ButtonSegment<_HashrateSeries>(
            value: _HashrateSeries.hashRate,
            label: Text('Hashrate'),
          ),
          const ButtonSegment<_HashrateSeries>(
            value: _HashrateSeries.hashRate2,
            label: Text('Hashrate2'),
          ),
          ButtonSegment<_HashrateSeries>(
            value: _HashrateSeries.both,
            label: Text(localizations.both),
          ),
        ],
        selected: <_HashrateSeries>{value},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onChanged(selection.first);
          }
        },
      ),
    );
  }
}

//(VIV [Hashrate Period Selector — 2026-10-04])

class _HashratePeriodSelector extends StatelessWidget {
  const _HashratePeriodSelector({required this.value, required this.onChanged});

  final _HashratePeriod value;

  final ValueChanged<_HashratePeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<_HashratePeriod>(
        segments: [
          ButtonSegment<_HashratePeriod>(
            value: _HashratePeriod.hour1,
            label: Text(localizations.hourLabel(1)),
          ),
          ButtonSegment<_HashratePeriod>(
            value: _HashratePeriod.hour3,
            label: Text(localizations.hourLabel(3)),
          ),
          ButtonSegment<_HashratePeriod>(
            value: _HashratePeriod.hour6,
            label: Text(localizations.hourLabel(6)),
          ),
          ButtonSegment<_HashratePeriod>(
            value: _HashratePeriod.hour12,
            label: Text(localizations.hourLabel(12)),
          ),
          ButtonSegment<_HashratePeriod>(
            value: _HashratePeriod.hour24,
            label: Text(localizations.hourLabel(24)),
          ),
          ButtonSegment<_HashratePeriod>(
            value: _HashratePeriod.all,
            label: Text(localizations.allTime),
          ),
        ],
        selected: <_HashratePeriod>{value},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onChanged(selection.first);
          }
        },
      ),
    );
  }
}

//(VIV [Landscape Hashrate Page — 2026-10-04])

class _LandscapeHashratePage extends StatefulWidget {
  const _LandscapeHashratePage({
    required this.history,
    required this.series,
    required this.period,
  });

  final List<HashrateHistory> history;

  final _HashrateSeries series;

  final _HashratePeriod period;

  @override
  State<_LandscapeHashratePage> createState() => _LandscapeHashratePageState();
}

//(VIV [Landscape Hashrate Page State — 2026-10-04])

class _LandscapeHashratePageState extends State<_LandscapeHashratePage> {
  @override
  void initState() {
    super.initState();

    //(VIV [Set Landscape Orientation — 2026-10-04])
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    //(VIV [Landscape Page Dispose — 2026-10-04])
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.hashrateHistory),
        actions: [
          IconButton(
            tooltip: localizations.returnToPortrait,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.fullscreen_exit),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
          child: Column(
            children: [
              Expanded(
                child: _LandscapeHashrateChart(
                  history: widget.history,
                  series: widget.series,
                  period: widget.period,
                ),
              ),
              const SizedBox(height: 8),
              _LandscapeLegend(series: widget.series),
            ],
          ),
        ),
      ),
    );
  }
}

//(VIV [Landscape Hashrate Chart — 2026-10-04])

class _LandscapeHashrateChart extends StatelessWidget {
  const _LandscapeHashrateChart({
    required this.history,
    required this.series,
    required this.period,
  });

  final List<HashrateHistory> history;

  final _HashrateSeries series;

  final _HashratePeriod period;

  @override
  Widget build(BuildContext context) {
    return LineChart(_buildChartData(context));
  }

  LineChartData _buildChartData(BuildContext context) {
    final chartScale = _calculateChartScale();

    final spots1 = <FlSpot>[];
    final spots2 = <FlSpot>[];

    for (var index = 0; index < history.length; index++) {
      final point = history[index];

      if (series == _HashrateSeries.hashRate ||
          series == _HashrateSeries.both) {
        spots1.add(FlSpot(index.toDouble(), point.hashRate));
      }

      if (series == _HashrateSeries.hashRate2 ||
          series == _HashrateSeries.both) {
        spots2.add(FlSpot(index.toDouble(), point.hashRate2));
      }
    }

    final bottomInterval = _bottomTitleInterval();

    final lineBars = <LineChartBarData>[];

    if (series == _HashrateSeries.hashRate || series == _HashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots1,
          isCurved: true,

          //(VIV [Landscape Thin Hashrate Line — 2026-10-04])
          barWidth: 1.5,

          dotData: const FlDotData(show: false),
        ),
      );
    }

    if (series == _HashrateSeries.hashRate2 || series == _HashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots2,
          isCurved: true,

          //(VIV [Landscape Thin Hashrate2 Line — 2026-10-04])
          barWidth: 1.5,

          dotData: const FlDotData(show: false),
        ),
      );
    }

    return LineChartData(
      minY: chartScale.minY,
      maxY: chartScale.maxY,
      minX: 0,
      maxX: history.length > 1 ? (history.length - 1).toDouble() : 1,
      gridData: FlGridData(
        show: true,
        horizontalInterval: chartScale.interval,
        verticalInterval: bottomInterval,
        drawVerticalLine: false,
      ),
      borderData: FlBorderData(show: true),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 70,
            interval: chartScale.interval,
            getTitlesWidget: (value, meta) {
              return Text(
                formatHashrate(value),
                style: Theme.of(context).textTheme.bodySmall,
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: bottomInterval,
            getTitlesWidget: (value, meta) {
              final index = value.round();

              if (index < 0 || index >= history.length) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                child: Text(
                  _formatTime(history[index].timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ),
      ),

      //(VIV [Landscape Hashrate Tooltip — 2026-10-04])
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.round();

              if (index < 0 || index >= history.length) {
                return null;
              }

              final point = history[index];

              final title = series == _HashrateSeries.both
                  ? spot.barIndex == 0
                        ? 'Hashrate'
                        : 'Hashrate2'
                  : series == _HashrateSeries.hashRate
                  ? 'Hashrate'
                  : 'Hashrate2';

              return LineTooltipItem(
                '${_formatTime(point.timestamp)}\n'
                '$title: ${formatHashrate(spot.y)}',
                Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: lineBars,
    );
  }

  _ChartScale _calculateChartScale() {
    var minValue = double.infinity;
    var maxValue = double.negativeInfinity;

    for (final point in history) {
      if (series == _HashrateSeries.hashRate ||
          series == _HashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate);

        maxValue = math.max(maxValue, point.hashRate);
      }

      if (series == _HashrateSeries.hashRate2 ||
          series == _HashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate2);

        maxValue = math.max(maxValue, point.hashRate2);
      }
    }

    if (!minValue.isFinite || !maxValue.isFinite) {
      return const _ChartScale(minY: 0, maxY: 1, interval: 0.2);
    }

    final range = maxValue - minValue;

    if (range <= 0) {
      final padding = math.max(maxValue.abs() * 0.05, 1);

      return _ChartScale(
        minY: maxValue - padding,
        maxY: maxValue + padding,
        interval: padding / 2,
      );
    }

    final padding = range * 0.10;

    var minY = minValue - padding;
    var maxY = maxValue + padding;

    final expandedRange = maxY - minY;

    final rawInterval = expandedRange / 5;
    final interval = _niceInterval(rawInterval);

    minY = (minY / interval).floor() * interval;
    maxY = (maxY / interval).ceil() * interval;

    return _ChartScale(minY: minY, maxY: maxY, interval: interval);
  }

  double _niceInterval(double value) {
    if (value <= 0 || !value.isFinite) {
      return 1;
    }

    final magnitude = math
        .pow(10, (math.log(value) / math.ln10).floor())
        .toDouble();

    final normalized = value / magnitude;

    double niceNormalized;

    if (normalized <= 1) {
      niceNormalized = 1;
    } else if (normalized <= 2) {
      niceNormalized = 2;
    } else if (normalized <= 5) {
      niceNormalized = 5;
    } else {
      niceNormalized = 10;
    }

    return niceNormalized * magnitude;
  }

  double _bottomTitleInterval() {
    if (history.length <= 1) {
      return 1;
    }

    const targetLabels = 10;

    if (history.length <= targetLabels) {
      return 1;
    }

    return ((history.length - 1) / (targetLabels - 1)).ceilToDouble();
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

//(VIV [Landscape Hashrate Legend — 2026-10-04])

class _LandscapeLegend extends StatelessWidget {
  const _LandscapeLegend({required this.series});

  final _HashrateSeries series;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    if (series == _HashrateSeries.hashRate || series == _HashrateSeries.both) {
      items.add(
        const _ChartLegendItem(label: 'Hashrate', icon: Icons.show_chart),
      );
    }

    if (series == _HashrateSeries.both) {
      items.add(const SizedBox(width: 24));
    }

    if (series == _HashrateSeries.hashRate2 || series == _HashrateSeries.both) {
      items.add(
        const _ChartLegendItem(label: 'Hashrate2', icon: Icons.timeline),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: items);
  }
}

//(VIV [Hashrate Chart Scale — 2026-10-04])

class _ChartScale {
  const _ChartScale({
    required this.minY,
    required this.maxY,
    required this.interval,
  });

  final double minY;
  final double maxY;
  final double interval;
}

//(VIV [Hashrate Chart Legend — 2026-10-04])

class _ChartLegendItem extends StatelessWidget {
  const _ChartLegendItem({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(label)],
    );
  }
}
