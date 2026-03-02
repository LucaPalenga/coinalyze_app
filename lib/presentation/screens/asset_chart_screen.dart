import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';

import '../../constants/sizes_config.dart';
import '../../core/constants/api_constants.dart';
import '../../data/datasources/coinalyze_remote_datasource.dart';
import '../../data/repositories/coinalyze_repository_impl.dart';
import '../../extensions/build_context.dart';
import '../viewmodels/asset_chart_viewmodel.dart';
import '../widgets/error_display_widget.dart';
import '../widgets/value_chip.dart';

// Chart accent colors
const _kGainColor = Color(0xFF26A69A);
const _kLossColor = Color(0xFFEF5350);

/// Main screen showing OHLCV price chart + Open Interest chart
/// stacked vertically, similar to the Coinalyze/TradingView layout.
class AssetChartScreen extends StatefulWidget {
  const AssetChartScreen({super.key});

  @override
  State<AssetChartScreen> createState() => _AssetChartScreenState();
}

class _AssetChartScreenState extends State<AssetChartScreen> {
  late final AssetChartViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AssetChartViewModel(
      repository: CoinalyzeRepositoryImpl(
        remoteDataSource: CoinalyzeRemoteDataSourceImpl(client: http.Client()),
      ),
    );
    _viewModel.loadData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: SafeArea(top: false, child: _buildBody()),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // AppBar
  // ---------------------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.currency_bitcoin, color: Color(0xFFF7931A), size: IconSize.medium),
          const SizedBox(width: SpacingSize.sm),
          Text(
            _viewModel.displayName,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: SpacingSize.md),
          _buildIntervalChip(),
        ],
      ),
      actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _viewModel.loadData)],
    );
  }

  Widget _buildIntervalChip() {
    final colors = context.colorScheme;
    return PopupMenuButton<TimeInterval>(
      color: colors.surfaceContainerHigh,
      onSelected: _viewModel.setInterval,
      itemBuilder: (context) => TimeInterval.values.map((interval) {
        final isSelected = interval == _viewModel.interval;
        return PopupMenuItem(
          value: interval,
          child: Text(
            interval.value,
            style: TextStyle(
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: SpacingSize.sm, vertical: SpacingSize.xs),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(BorderRadiusSize.xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _viewModel.interval.value,
              style: context.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(width: SpacingSize.xs),
            Icon(Icons.arrow_drop_down, color: colors.onSurfaceVariant, size: IconSize.smallest),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return Center(child: CircularProgressIndicator(color: context.colorScheme.primary));
    }

    if (_viewModel.error != null) {
      return ErrorDisplayWidget(error: _viewModel.error!, onRetry: _viewModel.loadData);
    }

    if (_viewModel.ohlcvCandles == null || _viewModel.ohlcvCandles!.isEmpty) {
      return Center(
        child: Text(
          context.l10n.no_data_available,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildOhlcvHeader(),
        Expanded(flex: 65, child: _buildPriceChart()),
        Divider(height: 1, thickness: 1, color: context.colorScheme.outlineVariant),
        _buildOiHeader(),
        Expanded(flex: 35, child: _buildOiChart()),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // OHLCV Header — chip-style O H L C + change %
  // ---------------------------------------------------------------------------

  Widget _buildOhlcvHeader() {
    final lastOhlcv = _viewModel.lastOhlcv;
    if (lastOhlcv == null) return const SizedBox.shrink();

    final o = lastOhlcv.o;
    final h = lastOhlcv.h;
    final l = lastOhlcv.l;
    final c = lastOhlcv.c;
    final change = (o != null && c != null) ? c - o : null;
    final changePct = (o != null && c != null && o != 0) ? ((c - o) / o) * 100 : null;
    final isPositive = (change ?? 0) >= 0;
    final changeColor = isPositive ? _kGainColor : _kLossColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SpacingSize.sm, vertical: SpacingSize.xs),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ValueChip(label: 'O', value: o?.toStringAsFixed(2), valueColor: changeColor),
            ValueChip(label: 'H', value: h?.toStringAsFixed(2), valueColor: changeColor),
            ValueChip(label: 'L', value: l?.toStringAsFixed(2), valueColor: changeColor),
            ValueChip(label: 'C', value: c?.toStringAsFixed(2), valueColor: changeColor),
            if (change != null && changePct != null)
              ValueChip(
                label: '%',
                value: '${change >= 0 ? '+' : ''}${changePct.toStringAsFixed(2)}%',
                valueColor: changeColor,
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OI Header — chip-style O H L C
  // ---------------------------------------------------------------------------

  Widget _buildOiHeader() {
    final lastOi = _viewModel.lastOi;
    if (lastOi == null) return const SizedBox.shrink();

    final o = lastOi.o;
    final h = lastOi.h;
    final l = lastOi.l;
    final c = lastOi.c;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SpacingSize.sm, vertical: SpacingSize.xs),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              context.l10n.aggregated_open_interest,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: SpacingSize.sm),
            ValueChip(label: 'O', value: _viewModel.formatBillions(o), valueColor: _kGainColor),
            ValueChip(label: 'H', value: _viewModel.formatBillions(h), valueColor: _kGainColor),
            ValueChip(label: 'L', value: _viewModel.formatBillions(l), valueColor: _kGainColor),
            ValueChip(label: 'C', value: _viewModel.formatBillions(c), valueColor: _kGainColor),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Charts
  // ---------------------------------------------------------------------------

  ChartStyle _chartStyle({double volumeHeightFactor = 0.0}) {
    final colors = context.colorScheme;
    return ChartStyle(
      priceGainColor: _kGainColor,
      priceLossColor: _kLossColor,
      volumeColor: volumeHeightFactor > 0 ? _kGainColor.withValues(alpha: 0.3) : Colors.transparent,
      priceGridLineColor: colors.outlineVariant.withValues(alpha: 0.3),
      priceLabelStyle: context.textTheme.labelSmall!.copyWith(
        color: colors.onSurfaceVariant.withValues(alpha: 0.6),
        fontSize: 10,
      ),
      timeLabelStyle: context.textTheme.labelSmall!.copyWith(
        color: colors.onSurfaceVariant.withValues(alpha: 0.6),
        fontSize: 10,
      ),
      selectionHighlightColor: colors.onSurface.withValues(alpha: 0.05),
      overlayBackgroundColor: colors.surfaceContainerHigh.withValues(alpha: 0.95),
      overlayTextStyle: context.textTheme.labelSmall!.copyWith(color: colors.onSurface),
      volumeHeightFactor: volumeHeightFactor,
    );
  }

  String Function(int, int) get _timeLabel => (timestamp, visibleDataCount) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (visibleDataCount > 120) {
      return DateFormat('MMM d').format(date);
    } else if (visibleDataCount > 60) {
      return DateFormat('d MMM').format(date);
    } else {
      return DateFormat('d MMM HH:mm').format(date);
    }
  };

  Widget _buildPriceChart() {
    return InteractiveChart(
      candles: _viewModel.ohlcvCandles!,
      initialVisibleCandleCount: 90,
      style: _chartStyle(volumeHeightFactor: 0.15),
      timeLabel: _timeLabel,
      priceLabel: (price) => price.toStringAsFixed(2),
      overlayInfo: (candle) => {
        context.l10n.open: candle.open?.toStringAsFixed(2) ?? '-',
        context.l10n.high: candle.high?.toStringAsFixed(2) ?? '-',
        context.l10n.low: candle.low?.toStringAsFixed(2) ?? '-',
        context.l10n.close: candle.close?.toStringAsFixed(2) ?? '-',
        context.l10n.volume: _viewModel.formatVolume(candle.volume),
      },
    );
  }

  Widget _buildOiChart() {
    if (_viewModel.oiCandles == null || _viewModel.oiCandles!.isEmpty) {
      return Center(
        child: Text(
          context.l10n.open_interest_not_available,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return InteractiveChart(
      candles: _viewModel.oiCandles!,
      initialVisibleCandleCount: 90,
      style: _chartStyle(),
      timeLabel: _timeLabel,
      priceLabel: (price) {
        if (price >= 1e9) return '${(price / 1e9).toStringAsFixed(1)}B';
        if (price >= 1e6) return '${(price / 1e6).toStringAsFixed(1)}M';
        if (price >= 1e3) return '${(price / 1e3).toStringAsFixed(1)}K';
        return price.toStringAsFixed(0);
      },
      overlayInfo: (candle) => {
        context.l10n.open: _viewModel.formatBillions(candle.open),
        context.l10n.high: _viewModel.formatBillions(candle.high),
        context.l10n.low: _viewModel.formatBillions(candle.low),
        context.l10n.close: _viewModel.formatBillions(candle.close),
      },
    );
  }
}
