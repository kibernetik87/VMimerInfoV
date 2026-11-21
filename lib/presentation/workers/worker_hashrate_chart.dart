//(VIV [Worker Hashrate Chart — 2026-10-04])

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/worker_hashrate_history.dart';
import '../../l10n/app_localizations.dart';

//(VIV [Worker Hashrate Series — 2026-10-04])

enum WorkerHashrateSeries { hashRate, hashRate2, both }

//(VIV [Worker Hashrate Period — 2026-10-04])

enum WorkerHashratePeriod { hour1, hour3, hour6, hour12, hour24, all }

//(VIV [Worker Hashrate Chart Widget — 2026-10-04])

class WorkerHashrateChart extends StatefulWidget {
  const WorkerHashrateChart({required this.history, super.key});

  final List<WorkerHashrateHistory> history;

  @override
  State<WorkerHashrateChart> createState() => _WorkerHashrateChartState();
}

//(VIV [Worker Hashrate Chart State — 2026-10-04])

class _WorkerHashrateChartState extends State<WorkerHashrateChart> {
  WorkerHashrateSeries _series = WorkerHashrateSeries.both;

  WorkerHashratePeriod _period = WorkerHashratePeriod.hour1;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final filteredHistory = _filterHistory(widget.history, _period);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                localizations.hashrateHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            //(VIV [Worker Hashrate Fullscreen Button — 2026-10-04])
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

        //(VIV [Worker Hashrate Series Selector — 2026-10-04])
        _WorkerHashrateSeriesSelector(
          value: _series,
          onChanged: (value) {
            setState(() {
              _series = value;
            });
          },
        ),

        const SizedBox(height: 12),

        //(VIV [Worker Hashrate Period Selector — 2026-10-04])
        _WorkerHashratePeriodSelector(
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
              //(VIV [Worker Hashrate Series Chart Key — 2026-10-04])
              key: ValueKey('worker-hashrate-${_series.name}-${_period.name}'),
              _buildChartData(context, history: filteredHistory, compact: true),
            ),
          ),

        const SizedBox(height: 12),

        _buildLegend(context),
      ],
    );
  }

  //(VIV [Open Worker Hashrate Fullscreen — 2026-10-04])

  void _openFullscreenChart(
    BuildContext context,
    List<WorkerHashrateHistory> filteredHistory,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) {
              return _WorkerLandscapeHashratePage(
                history: filteredHistory,
                series: _series,
                period: _period,
              );
            },
          ),
        )
        .then((_) {
          //(VIV [Restore Worker Portrait Orientation — 2026-10-04])
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        });
  }

  //(VIV [Worker Hashrate Legend — 2026-10-04])

  Widget _buildLegend(BuildContext context) {
    final items = <Widget>[];

    if (_series == WorkerHashrateSeries.hashRate ||
        _series == WorkerHashrateSeries.both) {
      items.add(
        _WorkerChartLegendItem(
          label: 'Hashrate',
          icon: Icons.show_chart,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (_series == WorkerHashrateSeries.both) {
      items.add(const SizedBox(width: 24));
    }

    if (_series == WorkerHashrateSeries.hashRate2 ||
        _series == WorkerHashrateSeries.both) {
      items.add(
        _WorkerChartLegendItem(
          label: 'Hashrate2',
          icon: Icons.timeline,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: items);
  }

  //(VIV [Worker Hashrate Chart Data — 2026-10-04])

  LineChartData _buildChartData(
    BuildContext context, {
    required List<WorkerHashrateHistory> history,
    required bool compact,
  }) {
    final chartScale = _calculateChartScale(history);

    final spots1 = <FlSpot>[];
    final spots2 = <FlSpot>[];

    for (var index = 0; index < history.length; index++) {
      final point = history[index];

      if (_series == WorkerHashrateSeries.hashRate ||
          _series == WorkerHashrateSeries.both) {
        spots1.add(FlSpot(index.toDouble(), point.hashRate));
      }

      if (_series == WorkerHashrateSeries.hashRate2 ||
          _series == WorkerHashrateSeries.both) {
        spots2.add(FlSpot(index.toDouble(), point.hashRate2));
      }
    }

    final bottomInterval = _bottomTitleInterval(
      history: history,
      compact: compact,
    );

    final lineBars = <LineChartBarData>[];

    //(VIV [Worker Hashrate Primary Line — 2026-10-04])

    if (_series == WorkerHashrateSeries.hashRate ||
        _series == WorkerHashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots1,
          isCurved: true,
          color: Theme.of(context).colorScheme.primary,

          //(VIV [Worker Thin Hashrate Line — 2026-10-04])
          barWidth: 1.5,

          dotData: const FlDotData(show: false),
        ),
      );
    }

    //(VIV [Worker Hashrate2 Secondary Line — 2026-10-04])

    if (_series == WorkerHashrateSeries.hashRate2 ||
        _series == WorkerHashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots2,
          isCurved: true,
          color: Theme.of(context).colorScheme.tertiary,

          //(VIV [Worker Thin Hashrate2 Line — 2026-10-04])
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

      //(VIV [Worker Cleaner Hashrate Grid — 2026-10-04])
      gridData: FlGridData(
        show: true,
        horizontalInterval: chartScale.interval,
        verticalInterval: bottomInterval,
        drawVerticalLine: false,
      ),

      borderData: FlBorderData(show: true),

      //(VIV [Worker Hashrate Chart Titles — 2026-10-04])
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

      //(VIV [Worker Hashrate Touch Tooltip — 2026-10-04])
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            final localizations = AppLocalizations.of(context)!;

            return touchedSpots.map((spot) {
              final index = spot.x.round();

              if (index < 0 || index >= history.length) {
                return null;
              }

              final point = history[index];

              final title = _tooltipTitle(spot, localizations);

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

  //(VIV [Worker Hashrate Tooltip Title — 2026-10-04])

  String _tooltipTitle(LineBarSpot spot, AppLocalizations localizations) {
    if (_series == WorkerHashrateSeries.both) {
      return spot.barIndex == 0 ? 'Hashrate' : 'Hashrate2';
    }

    if (_series == WorkerHashrateSeries.hashRate) {
      return 'Hashrate';
    }

    return 'Hashrate2';
  }

  //(VIV [Worker Hashrate History Filter — 2026-10-04])

  List<WorkerHashrateHistory> _filterHistory(
    List<WorkerHashrateHistory> source,
    WorkerHashratePeriod period,
  ) {
    if (source.isEmpty) {
      return const [];
    }

    final sorted = List<WorkerHashrateHistory>.from(source)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (period == WorkerHashratePeriod.all) {
      return sorted;
    }

    final latest = sorted.last;

    final duration = switch (period) {
      WorkerHashratePeriod.hour1 => const Duration(hours: 1),
      WorkerHashratePeriod.hour3 => const Duration(hours: 3),
      WorkerHashratePeriod.hour6 => const Duration(hours: 6),
      WorkerHashratePeriod.hour12 => const Duration(hours: 12),
      WorkerHashratePeriod.hour24 => const Duration(hours: 24),
      WorkerHashratePeriod.all => Duration.zero,
    };

    final cutoff = latest.timestamp.subtract(duration);

    return sorted.where((point) => !point.timestamp.isBefore(cutoff)).toList();
  }

  //(VIV [Worker Dynamic Hashrate Chart Scale — 2026-10-04])

  _WorkerChartScale _calculateChartScale(List<WorkerHashrateHistory> history) {
    var minValue = double.infinity;
    var maxValue = double.negativeInfinity;

    for (final point in history) {
      if (_series == WorkerHashrateSeries.hashRate ||
          _series == WorkerHashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate);

        maxValue = math.max(maxValue, point.hashRate);
      }

      if (_series == WorkerHashrateSeries.hashRate2 ||
          _series == WorkerHashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate2);

        maxValue = math.max(maxValue, point.hashRate2);
      }
    }

    if (!minValue.isFinite || !maxValue.isFinite) {
      return const _WorkerChartScale(minY: 0, maxY: 1, interval: 0.2);
    }

    final range = maxValue - minValue;

    if (range <= 0) {
      final padding = math.max(maxValue.abs() * 0.05, 1);

      return _WorkerChartScale(
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

    return _WorkerChartScale(minY: minY, maxY: maxY, interval: interval);
  }

  //(VIV [Worker Nice Hashrate Chart Interval — 2026-10-04])

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

  //(VIV [Worker Compact X Axis — 2026-10-04])

  double _bottomTitleInterval({
    required List<WorkerHashrateHistory> history,
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

  //(VIV [Worker Hashrate Time Format — 2026-10-04])

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

//(VIV [Worker Hashrate Series Selector — 2026-10-04])

class _WorkerHashrateSeriesSelector extends StatelessWidget {
  const _WorkerHashrateSeriesSelector({
    required this.value,
    required this.onChanged,
  });

  final WorkerHashrateSeries value;

  final ValueChanged<WorkerHashrateSeries> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<WorkerHashrateSeries>(
        segments: [
          const ButtonSegment<WorkerHashrateSeries>(
            value: WorkerHashrateSeries.hashRate,
            label: Text('Hashrate'),
          ),
          const ButtonSegment<WorkerHashrateSeries>(
            value: WorkerHashrateSeries.hashRate2,
            label: Text('Hashrate2'),
          ),
          ButtonSegment<WorkerHashrateSeries>(
            value: WorkerHashrateSeries.both,
            label: Text(localizations.both),
          ),
        ],
        selected: <WorkerHashrateSeries>{value},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onChanged(selection.first);
          }
        },
      ),
    );
  }
}

//(VIV [Worker Hashrate Period Selector — 2026-10-04])

class _WorkerHashratePeriodSelector extends StatelessWidget {
  const _WorkerHashratePeriodSelector({
    required this.value,
    required this.onChanged,
  });

  final WorkerHashratePeriod value;

  final ValueChanged<WorkerHashratePeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<WorkerHashratePeriod>(
        segments: [
          ButtonSegment<WorkerHashratePeriod>(
            value: WorkerHashratePeriod.hour1,
            label: Text(localizations.hourLabel(1)),
          ),
          ButtonSegment<WorkerHashratePeriod>(
            value: WorkerHashratePeriod.hour3,
            label: Text(localizations.hourLabel(3)),
          ),
          ButtonSegment<WorkerHashratePeriod>(
            value: WorkerHashratePeriod.hour6,
            label: Text(localizations.hourLabel(6)),
          ),
          ButtonSegment<WorkerHashratePeriod>(
            value: WorkerHashratePeriod.hour12,
            label: Text(localizations.hourLabel(12)),
          ),
          ButtonSegment<WorkerHashratePeriod>(
            value: WorkerHashratePeriod.hour24,
            label: Text(localizations.hourLabel(24)),
          ),
          ButtonSegment<WorkerHashratePeriod>(
            value: WorkerHashratePeriod.all,
            label: Text(localizations.allTime),
          ),
        ],
        selected: <WorkerHashratePeriod>{value},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onChanged(selection.first);
          }
        },
      ),
    );
  }
}

//(VIV [Worker Landscape Hashrate Page — 2026-10-04])

class _WorkerLandscapeHashratePage extends StatefulWidget {
  const _WorkerLandscapeHashratePage({
    required this.history,
    required this.series,
    required this.period,
  });

  final List<WorkerHashrateHistory> history;
  final WorkerHashrateSeries series;
  final WorkerHashratePeriod period;

  @override
  State<_WorkerLandscapeHashratePage> createState() =>
      _WorkerLandscapeHashratePageState();
}

//(VIV [Worker Landscape Hashrate Page State — 2026-10-04])

class _WorkerLandscapeHashratePageState
    extends State<_WorkerLandscapeHashratePage> {
  @override
  void initState() {
    super.initState();

    //(VIV [Set Worker Landscape Orientation — 2026-10-04])
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    //(VIV [Worker Landscape Page Dispose — 2026-10-04])
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.workerHashrateHistory),
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
                child: _WorkerLandscapeHashrateChart(
                  history: widget.history,
                  series: widget.series,
                  period: widget.period,
                ),
              ),
              const SizedBox(height: 8),
              _WorkerLandscapeLegend(series: widget.series),
            ],
          ),
        ),
      ),
    );
  }
}

//(VIV [Worker Landscape Hashrate Chart — 2026-10-04])

class _WorkerLandscapeHashrateChart extends StatelessWidget {
  const _WorkerLandscapeHashrateChart({
    required this.history,
    required this.series,
    required this.period,
  });

  final List<WorkerHashrateHistory> history;
  final WorkerHashrateSeries series;
  final WorkerHashratePeriod period;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      key: ValueKey('worker-landscape-hashrate-${series.name}-${period.name}'),
      _buildChartData(context),
    );
  }

  LineChartData _buildChartData(BuildContext context) {
    final chartScale = _calculateChartScale();

    final spots1 = <FlSpot>[];
    final spots2 = <FlSpot>[];

    for (var index = 0; index < history.length; index++) {
      final point = history[index];

      if (series == WorkerHashrateSeries.hashRate ||
          series == WorkerHashrateSeries.both) {
        spots1.add(FlSpot(index.toDouble(), point.hashRate));
      }

      if (series == WorkerHashrateSeries.hashRate2 ||
          series == WorkerHashrateSeries.both) {
        spots2.add(FlSpot(index.toDouble(), point.hashRate2));
      }
    }

    final bottomInterval = _bottomTitleInterval();

    final lineBars = <LineChartBarData>[];

    if (series == WorkerHashrateSeries.hashRate ||
        series == WorkerHashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots1,
          isCurved: true,
          color: Theme.of(context).colorScheme.primary,

          //(VIV [Worker Landscape Thin Hashrate Line — 2026-10-04])
          barWidth: 1.5,

          dotData: const FlDotData(show: false),
        ),
      );
    }

    if (series == WorkerHashrateSeries.hashRate2 ||
        series == WorkerHashrateSeries.both) {
      lineBars.add(
        LineChartBarData(
          spots: spots2,
          isCurved: true,
          color: Theme.of(context).colorScheme.tertiary,

          //(VIV [Worker Landscape Thin Hashrate2 Line — 2026-10-04])
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

      //(VIV [Worker Landscape Hashrate Tooltip — 2026-10-04])
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

              final title = series == WorkerHashrateSeries.both
                  ? spot.barIndex == 0
                        ? 'Hashrate'
                        : 'Hashrate2'
                  : series == WorkerHashrateSeries.hashRate
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

  _WorkerChartScale _calculateChartScale() {
    var minValue = double.infinity;
    var maxValue = double.negativeInfinity;

    for (final point in history) {
      if (series == WorkerHashrateSeries.hashRate ||
          series == WorkerHashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate);

        maxValue = math.max(maxValue, point.hashRate);
      }

      if (series == WorkerHashrateSeries.hashRate2 ||
          series == WorkerHashrateSeries.both) {
        minValue = math.min(minValue, point.hashRate2);

        maxValue = math.max(maxValue, point.hashRate2);
      }
    }

    if (!minValue.isFinite || !maxValue.isFinite) {
      return const _WorkerChartScale(minY: 0, maxY: 1, interval: 0.2);
    }

    final range = maxValue - minValue;

    if (range <= 0) {
      final padding = math.max(maxValue.abs() * 0.05, 1);

      return _WorkerChartScale(
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

    return _WorkerChartScale(minY: minY, maxY: maxY, interval: interval);
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

//(VIV [Worker Landscape Legend — 2026-10-04])

class _WorkerLandscapeLegend extends StatelessWidget {
  const _WorkerLandscapeLegend({required this.series});

  final WorkerHashrateSeries series;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    if (series == WorkerHashrateSeries.hashRate ||
        series == WorkerHashrateSeries.both) {
      items.add(
        _WorkerChartLegendItem(
          label: 'Hashrate',
          icon: Icons.show_chart,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (series == WorkerHashrateSeries.both) {
      items.add(const SizedBox(width: 24));
    }

    if (series == WorkerHashrateSeries.hashRate2 ||
        series == WorkerHashrateSeries.both) {
      items.add(
        _WorkerChartLegendItem(
          label: 'Hashrate2',
          icon: Icons.timeline,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: items);
  }
}

//(VIV [Worker Chart Scale — 2026-10-04])

class _WorkerChartScale {
  const _WorkerChartScale({
    required this.minY,
    required this.maxY,
    required this.interval,
  });

  final double minY;
  final double maxY;
  final double interval;
}

//(VIV [Worker Chart Legend Item — 2026-10-04])

class _WorkerChartLegendItem extends StatelessWidget {
  const _WorkerChartLegendItem({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
