import 'package:flutter/foundation.dart';
import 'package:interactive_chart/interactive_chart.dart';

import '../../core/constants/api_constants.dart';
import '../../data/models/models.dart';
import '../../domain/repositories/coinalyze_repository.dart';

/// ViewModel for the asset chart screen.
///
/// Manages all data fetching, state transitions (loading / error / data),
/// and exposes read-only properties that the UI observes via [ChangeNotifier].
class AssetChartViewModel extends ChangeNotifier {
  final CoinalyzeRepository _repository;

  AssetChartViewModel({required CoinalyzeRepository repository}) : _repository = repository;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  // Available assets from API
  List<FutureMarketInfoModel> _availableAssets = [];
  List<FutureMarketInfoModel> get availableAssets => _availableAssets;

  bool _isLoadingAssets = false;
  bool get isLoadingAssets => _isLoadingAssets;

  // Primary chart (OHLCV)
  List<CandleData>? _ohlcvCandles;
  List<CandleData>? get ohlcvCandles => _ohlcvCandles;

  OhlcvPerIntervalModel? _lastOhlcv;
  OhlcvPerIntervalModel? get lastOhlcv => _lastOhlcv;

  // Secondary chart (dynamic)
  List<CandleData>? _secondaryCandles;
  List<CandleData>? get secondaryCandles => _secondaryCandles;

  bool _isLoadingSecondary = false;
  bool get isLoadingSecondary => _isLoadingSecondary;

  /// Generic map of last values for the secondary chart header.
  Map<String, double?>? _secondaryLastValues;
  Map<String, double?>? get secondaryLastValues => _secondaryLastValues;

  // Selected asset
  FutureMarketInfoModel? _selectedAsset;
  FutureMarketInfoModel? get selectedAsset => _selectedAsset;

  /// Display name derived from selected asset (e.g. "BTC/USDT Perp").
  String get displayName {
    final a = _selectedAsset;
    if (a == null) return '';
    final base = a.baseAsset ?? '';
    final quote = a.quoteAsset ?? '';
    final suffix = a.isPerpetual == true ? ' Perp' : '';
    return '$base/$quote$suffix';
  }

  // Interval
  TimeInterval _interval = TimeInterval.oneHour;
  TimeInterval get interval => _interval;

  // Secondary chart type
  SecondaryChartType _secondaryChartType = SecondaryChartType.openInterest;
  SecondaryChartType get secondaryChartType => _secondaryChartType;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Loads the list of available future markets from the API.
  /// Filters to aggregated perpetuals and sorts by baseAsset.
  Future<void> loadAvailableAssets() async {
    _isLoadingAssets = true;
    notifyListeners();

    try {
      final markets = await _repository.getFutureMarkets();
      // Filter: aggregated perpetuals only (symbol ends with _PERP.A)
      // Preserve API order (market cap / popularity, same as Coinalyze website)
      _availableAssets = markets
          .where((m) => m.isPerpetual == true && m.symbol != null && m.symbol!.endsWith('_PERP.A'))
          .toList();

      // Select BTC as default if available, otherwise first
      _selectedAsset = _availableAssets.firstWhere(
        (m) => m.baseAsset == 'BTC',
        orElse: () => _availableAssets.first,
      );

      _isLoadingAssets = false;
      notifyListeners();
    } catch (e) {
      _isLoadingAssets = false;
      _error = e;
      notifyListeners();
    }
  }

  /// Changes the selected asset and reloads data.
  void setAsset(FutureMarketInfoModel asset) {
    _selectedAsset = asset;
    loadData();
  }

  /// Changes the time interval and reloads data.
  void setInterval(TimeInterval interval) {
    _interval = interval;
    loadData();
  }

  /// Changes the secondary chart type and reloads only the secondary data.
  void setSecondaryChartType(SecondaryChartType type) {
    _secondaryChartType = type;
    _loadSecondaryOnly();
  }

  /// Reloads only the secondary chart without touching the primary OHLCV data.
  Future<void> _loadSecondaryOnly() async {
    if (_selectedAsset?.symbol == null) return;

    _secondaryCandles = null;
    _secondaryLastValues = null;
    _isLoadingSecondary = true;
    notifyListeners();

    final now = DateTime.now();
    final to = now.millisecondsSinceEpoch ~/ 1000;
    final from = to - _getFromDuration();
    final symbol = _selectedAsset!.symbol!;

    try {
      final result = await _fetchSecondaryData(symbol, from, to);
      _parseSecondaryResult(result);
    } catch (_) {
      // Non-fatal
    }
    _isLoadingSecondary = false;
    notifyListeners();
  }

  /// Fetches OHLCV first (so the primary chart renders fast), then loads
  /// the secondary chart data in a second phase to avoid building both
  /// heavy chart widgets in the same frame.
  Future<void> loadData() async {
    if (_selectedAsset?.symbol == null) return;

    _isLoading = true;
    _error = null;
    _secondaryCandles = null;
    _secondaryLastValues = null;
    notifyListeners();

    final now = DateTime.now();
    final to = now.millisecondsSinceEpoch ~/ 1000;
    final from = to - _getFromDuration();
    final symbol = _selectedAsset!.symbol!;

    // Phase 1: load OHLCV
    try {
      final ohlcvList = await _repository.getOhlcvHistory(
        symbols: symbol,
        interval: _interval,
        from: from,
        to: to,
      );
      final ohlcvHistory = ohlcvList.isNotEmpty ? ohlcvList.first.history : null;

      _ohlcvCandles = ohlcvHistory?.map((e) {
        return CandleData(
          timestamp: (e.t ?? 0) * 1000,
          open: e.o,
          high: e.h,
          low: e.l,
          close: e.c,
          volume: e.v,
        );
      }).toList();

      _lastOhlcv = ohlcvHistory?.isNotEmpty == true ? ohlcvHistory!.last : null;

      _isLoading = false;
      _isLoadingSecondary = true;
      notifyListeners();
    } catch (e) {
      _error = e;
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Phase 2: load secondary chart (primary is already visible)
    try {
      final result = await _fetchSecondaryData(symbol, from, to);
      _parseSecondaryResult(result);
    } catch (_) {
      // Secondary data failure is non-fatal; chart will show "not available"
    }
    _isLoadingSecondary = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Secondary data fetching
  // ---------------------------------------------------------------------------

  Future<dynamic> _fetchSecondaryData(String symbol, int from, int to) {
    switch (_secondaryChartType) {
      case SecondaryChartType.openInterest:
        return _repository.getOpenInterestHistory(
          symbols: symbol,
          interval: _interval,
          from: from,
          to: to,
          convertToUsd: true,
        );
      case SecondaryChartType.fundingRate:
        return _repository.getFundingRateHistory(
          symbols: symbol,
          interval: _interval,
          from: from,
          to: to,
        );
      case SecondaryChartType.liquidations:
        return _repository.getLiquidationHistory(
          symbols: symbol,
          interval: _interval,
          from: from,
          to: to,
          convertToUsd: true,
        );
      case SecondaryChartType.longShortRatio:
        return _repository.getLongShortRatioHistory(
          symbols: symbol,
          interval: _interval,
          from: from,
          to: to,
        );
    }
  }

  void _parseSecondaryResult(dynamic result) {
    _secondaryCandles = null;
    _secondaryLastValues = null;

    switch (_secondaryChartType) {
      case SecondaryChartType.openInterest:
        final list = result as List<OpenInterestHistoryModel>;
        final history = list.isNotEmpty ? list.first.history : null;
        _secondaryCandles = history?.map((e) {
          return CandleData(
            timestamp: (e.t ?? 0) * 1000,
            open: e.o,
            high: e.h,
            low: e.l,
            close: e.c,
            volume: 0,
          );
        }).toList();
        if (history?.isNotEmpty == true) {
          final last = history!.last;
          _secondaryLastValues = {'o': last.o, 'h': last.h, 'l': last.l, 'c': last.c};
        }

      case SecondaryChartType.fundingRate:
        final list = result as List<FundingRateHistoryModel>;
        final history = list.isNotEmpty ? list.first.history : null;
        // Funding rate: O=H=L=C is common for aggregated data, making candle
        // bodies invisible. Use trends[] for line rendering (same as L/S ratio).
        _secondaryCandles = history?.map((e) {
          return CandleData(
            timestamp: (e.t ?? 0) * 1000,
            open: e.c,
            close: e.c,
            high: null,
            low: null,
            volume: 0,
            trends: [e.c],
          );
        }).toList();
        if (history?.isNotEmpty == true) {
          final last = history!.last;
          _secondaryLastValues = {'o': last.o, 'h': last.h, 'l': last.l, 'c': last.c};
        }

      case SecondaryChartType.liquidations:
        final list = result as List<LiquidationHistoryModel>;
        final history = list.isNotEmpty ? list.first.history : null;
        // Liquidations: longs (l) and shorts (s) as volume bars.
        // Use open=0, close=0 (invisible body) and show as volume.
        _secondaryCandles = history?.map((e) {
          final total = (e.l ?? 0) + (e.s ?? 0);
          return CandleData(
            timestamp: (e.t ?? 0) * 1000,
            open: total > 0 ? total : null,
            high: total > 0 ? total : null,
            low: 0,
            close: 0,
            volume: total > 0 ? total : null,
          );
        }).toList();
        if (history?.isNotEmpty == true) {
          final last = history!.last;
          _secondaryLastValues = {'longs': last.l, 'shorts': last.s};
        }

      case SecondaryChartType.longShortRatio:
        final list = result as List<LongShortRatioHistoryModel>;
        final history = list.isNotEmpty ? list.first.history : null;
        // L/S ratio: use CandleData.trends for line rendering.
        // Set OHLC to null so no candle body is drawn, only the trend line.
        // We need a dummy open/close pair so the chart computes price range.
        _secondaryCandles = history?.map((e) {
          return CandleData(
            timestamp: (e.t ?? 0) * 1000,
            open: e.r,
            close: e.r,
            high: null,
            low: null,
            volume: 0,
            trends: [e.r],
          );
        }).toList();
        if (history?.isNotEmpty == true) {
          final last = history!.last;
          _secondaryLastValues = {'ratio': last.r, 'longs': last.l, 'shorts': last.s};
        }
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  int _getFromDuration() {
    switch (_interval) {
      case TimeInterval.oneMin:
        return 6 * 3600;
      case TimeInterval.fiveMin:
        return 24 * 3600;
      case TimeInterval.fifteenMin:
        return 3 * 24 * 3600;
      case TimeInterval.thirtyMin:
        return 5 * 24 * 3600;
      case TimeInterval.oneHour:
        return 14 * 24 * 3600;
      case TimeInterval.twoHour:
        return 21 * 24 * 3600;
      case TimeInterval.fourHour:
        return 30 * 24 * 3600;
      case TimeInterval.sixHour:
        return 45 * 24 * 3600;
      case TimeInterval.twelveHour:
        return 90 * 24 * 3600;
      case TimeInterval.daily:
        return 180 * 24 * 3600;
    }
  }

  // ---------------------------------------------------------------------------
  // Formatting utilities
  // ---------------------------------------------------------------------------

  String formatVolume(double? vol) {
    if (vol == null) return '-';
    if (vol >= 1e9) return '${(vol / 1e9).toStringAsFixed(2)}B';
    if (vol >= 1e6) return '${(vol / 1e6).toStringAsFixed(2)}M';
    if (vol >= 1e3) return '${(vol / 1e3).toStringAsFixed(2)}K';
    return vol.toStringAsFixed(2);
  }

  String formatBillions(double? val) {
    if (val == null) return '-';
    if (val >= 1e9) return '${(val / 1e9).toStringAsFixed(3)}B';
    if (val >= 1e6) return '${(val / 1e6).toStringAsFixed(2)}M';
    if (val >= 1e3) return '${(val / 1e3).toStringAsFixed(2)}K';
    return val.toStringAsFixed(2);
  }

  String formatPercent(double? val) {
    if (val == null) return '-';
    return '${(val * 100).toStringAsFixed(4)}%';
  }

  String formatRatio(double? val) {
    if (val == null) return '-';
    return val.toStringAsFixed(2);
  }
}
