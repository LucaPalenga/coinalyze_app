import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';

import '../../constants/sizes_config.dart';
import '../../core/constants/api_constants.dart';
import '../../data/datasources/coinalyze_remote_datasource.dart';
import '../../data/models/models.dart';
import '../../data/repositories/coinalyze_repository_impl.dart';
import '../../extensions/build_context.dart';
import '../viewmodels/asset_chart_viewmodel.dart';
import '../widgets/error_display_widget.dart';
import '../widgets/selection_dialog.dart';
import '../widgets/selector_button.dart';
import '../widgets/synced_interactive_chart.dart';
import '../widgets/value_chip.dart';
import 'asset_selection_screen.dart';

// Chart accent colors
const _kGainColor = Color(0xFF26A69A);
const _kLossColor = Color(0xFFEF5350);

/// Main screen showing OHLCV price chart + secondary indicator chart
/// stacked vertically, similar to the Coinalyze/TradingView layout.
class AssetChartScreen extends StatefulWidget {
  const AssetChartScreen({super.key});

  @override
  State<AssetChartScreen> createState() => _AssetChartScreenState();
}

class _AssetChartScreenState extends State<AssetChartScreen> {
  late final AssetChartViewModel _viewModel;
  final _scrollController = ChartScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = AssetChartViewModel(
      repository: CoinalyzeRepositoryImpl(
        remoteDataSource: CoinalyzeRemoteDataSourceImpl(client: http.Client()),
      ),
    );
    _initData();
  }

  Future<void> _initData() async {
    await _viewModel.loadAvailableAssets();
    if (_viewModel.selectedAsset != null) {
      _viewModel.loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          _buildAssetSelector(),
          const SizedBox(width: SpacingSize.md),
          _buildIntervalChip(),
        ],
      ),
      actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _viewModel.loadData)],
    );
  }

  Widget _buildAssetSelector() {
    final colors = context.colorScheme;
    final baseAsset = _viewModel.selectedAsset?.baseAsset ?? '';
    return GestureDetector(
      onTap: _openAssetSelection,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingSize.xs,
              vertical: SpacingSize.xxs,
            ),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(BorderRadiusSize.xs),
            ),
            child: Text(
              baseAsset.isNotEmpty ? baseAsset : '...',
              style: context.textTheme.labelMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: SpacingSize.sm),
          Text(
            _viewModel.displayName.isNotEmpty ? _viewModel.displayName : '...',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> _openAssetSelection() async {
    final result = await Navigator.of(context).push<FutureMarketInfoModel>(
      MaterialPageRoute(
        builder: (_) => AssetSelectionScreen(
          assets: _viewModel.availableAssets,
          selectedAsset: _viewModel.selectedAsset,
        ),
      ),
    );
    if (result != null) {
      _viewModel.setAsset(result);
    }
  }

  Widget _buildIntervalChip() {
    return SelectorButton(label: _viewModel.interval.value, onTap: _openIntervalSelection);
  }

  Future<void> _openIntervalSelection() async {
    final result = await showSelectionDialog<TimeInterval>(
      context: context,
      title: context.l10n.select_interval,
      items: TimeInterval.values.map((i) => SelectionItem(value: i, label: i.value)).toList(),
      selectedValue: _viewModel.interval,
    );
    if (result != null) {
      _viewModel.setInterval(result);
    }
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    if (_viewModel.isLoadingAssets || _viewModel.isLoading) {
      return Center(child: CircularProgressIndicator(color: context.colorScheme.primary));
    }

    if (_viewModel.error != null) {
      return ErrorDisplayWidget(error: _viewModel.error!, onRetry: _initData);
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
        _buildChartTypeButton(),
        Expanded(flex: 35, child: _buildSecondaryChart()),
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
  // Chart type selector — single button + dialog
  // ---------------------------------------------------------------------------

  String _chartTypeLabel(SecondaryChartType type) {
    switch (type) {
      case SecondaryChartType.openInterest:
        return context.l10n.chart_open_interest;
      case SecondaryChartType.fundingRate:
        return context.l10n.chart_funding_rate;
      case SecondaryChartType.liquidations:
        return context.l10n.chart_liquidations;
      case SecondaryChartType.longShortRatio:
        return context.l10n.chart_long_short_ratio;
    }
  }

  Widget _buildChartTypeButton() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: SpacingSize.sm),
      alignment: Alignment.centerLeft,
      child: SelectorButton(
        label: _chartTypeLabel(_viewModel.secondaryChartType),
        onTap: _openChartTypeSelection,
      ),
    );
  }

  Future<void> _openChartTypeSelection() async {
    final result = await showSelectionDialog<SecondaryChartType>(
      context: context,
      title: context.l10n.select_chart_type,
      items: SecondaryChartType.values
          .map((t) => SelectionItem(value: t, label: _chartTypeLabel(t)))
          .toList(),
      selectedValue: _viewModel.secondaryChartType,
    );
    if (result != null) {
      _viewModel.setSecondaryChartType(result);
    }
  }

  // ---------------------------------------------------------------------------
  // Charts
  // ---------------------------------------------------------------------------

  ChartStyle _chartStyle({
    double volumeHeightFactor = 0.0,
    List<Paint>? trendLineStyles,
    double priceLabelWidth = 40.0,
  }) {
    final colors = context.colorScheme;
    return ChartStyle(
      priceGainColor: _kGainColor,
      priceLossColor: _kLossColor,
      volumeColor: volumeHeightFactor > 0 ? _kGainColor.withValues(alpha: 0.3) : Colors.transparent,
      priceGridLineColor: colors.outlineVariant.withValues(alpha: 0.3),
      priceLabelWidth: priceLabelWidth,
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
      trendLineStyles: trendLineStyles ?? [],
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

  /// Compact price label for the primary OHLCV chart.
  /// Shows up to 2 decimal places, abbreviated for large values.
  String _primaryPriceLabel(double price) {
    final abs = price.abs();
    if (abs >= 1e6) return '${(price / 1e6).toStringAsFixed(1)}M';
    if (abs >= 1e4) return price.toStringAsFixed(0);
    if (abs >= 1) return price.toStringAsFixed(2);
    // Small prices: show enough precision
    return price.toStringAsFixed(4);
  }

  /// Price label for secondary charts — 2 decimal places (rounded up).
  String _secondaryCeilLabel(double price) {
    // Ceil to 2 decimal places
    final factor = 100.0;
    final ceiled = (price * factor).ceilToDouble() / factor;
    return ceiled.toStringAsFixed(2);
  }

  Widget _buildPriceChart() {
    return SyncedInteractiveChart(
      candles: _viewModel.ohlcvCandles!,
      initialVisibleCandleCount: 90,
      scrollController: _scrollController,
      style: _chartStyle(volumeHeightFactor: 0.15),
      timeLabel: _timeLabel,
      priceLabel: _primaryPriceLabel,
      overlayInfo: (candle) => {
        context.l10n.open: candle.open?.toStringAsFixed(2) ?? '-',
        context.l10n.high: candle.high?.toStringAsFixed(2) ?? '-',
        context.l10n.low: candle.low?.toStringAsFixed(2) ?? '-',
        context.l10n.close: candle.close?.toStringAsFixed(2) ?? '-',
        context.l10n.volume: _viewModel.formatVolume(candle.volume),
      },
    );
  }

  String Function(double) get _secondaryPriceLabel {
    switch (_viewModel.secondaryChartType) {
      case SecondaryChartType.openInterest:
      case SecondaryChartType.liquidations:
        return (price) {
          final abs = price.abs();
          if (abs >= 1e9) return '${(price / 1e9).toStringAsFixed(2)}B';
          if (abs >= 1e6) return '${(price / 1e6).toStringAsFixed(2)}M';
          if (abs >= 1e3) return '${(price / 1e3).toStringAsFixed(2)}K';
          return _secondaryCeilLabel(price);
        };
      case SecondaryChartType.fundingRate:
        return (price) {
          // Ceil to 2 decimal places after converting to percentage
          final pct = price * 100;
          final ceiled = (pct * 100).ceilToDouble() / 100;
          return '${ceiled.toStringAsFixed(2)}%';
        };
      case SecondaryChartType.longShortRatio:
        return _secondaryCeilLabel;
    }
  }

  Map<String, String> Function(CandleData) get _secondaryOverlayInfo {
    switch (_viewModel.secondaryChartType) {
      case SecondaryChartType.openInterest:
        return (candle) => {
          context.l10n.open: _viewModel.formatBillions(candle.open),
          context.l10n.high: _viewModel.formatBillions(candle.high),
          context.l10n.low: _viewModel.formatBillions(candle.low),
          context.l10n.close: _viewModel.formatBillions(candle.close),
        };
      case SecondaryChartType.fundingRate:
        return (candle) => {
          context.l10n.open: _viewModel.formatPercent(candle.open),
          context.l10n.high: _viewModel.formatPercent(candle.high),
          context.l10n.low: _viewModel.formatPercent(candle.low),
          context.l10n.close: _viewModel.formatPercent(candle.close),
        };
      case SecondaryChartType.liquidations:
        return (candle) => {
          context.l10n.longs: _viewModel.formatBillions(candle.open),
          context.l10n.shorts: _viewModel.formatBillions(candle.close),
        };
      case SecondaryChartType.longShortRatio:
        return (candle) => {context.l10n.ratio: _viewModel.formatRatio(candle.close)};
    }
  }

  Widget _buildSecondaryChart() {
    if (_viewModel.isLoadingSecondary) {
      return Center(
        child: SizedBox(
          width: IconSize.medium,
          height: IconSize.medium,
          child: CircularProgressIndicator(strokeWidth: 2, color: context.colorScheme.primary),
        ),
      );
    }

    final candles = _viewModel.secondaryCandles;
    if (candles == null || candles.isEmpty) {
      return Center(
        child: Text(
          context.l10n.secondary_chart_not_available,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final type = _viewModel.secondaryChartType;
    final useTrendLine =
        type == SecondaryChartType.longShortRatio || type == SecondaryChartType.fundingRate;
    final isLiquidations = type == SecondaryChartType.liquidations;

    return SyncedInteractiveChart(
      candles: candles,
      initialVisibleCandleCount: 90,
      scrollController: _scrollController,
      style: _chartStyle(
        volumeHeightFactor: isLiquidations ? 0.5 : 0.0,
        trendLineStyles: useTrendLine
            ? [
                Paint()
                  ..strokeWidth = 2.0
                  ..strokeCap = StrokeCap.round
                  ..color = _kGainColor,
              ]
            : null,
      ),
      timeLabel: _timeLabel,
      priceLabel: _secondaryPriceLabel,
      overlayInfo: _secondaryOverlayInfo,
    );
  }
}
