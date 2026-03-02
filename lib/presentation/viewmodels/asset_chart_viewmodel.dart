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

  AssetChartViewModel({required CoinalyzeRepository repository})
      : _repository = repository;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  List<CandleData>? _ohlcvCandles;
  List<CandleData>? get ohlcvCandles => _ohlcvCandles;

  List<CandleData>? _oiCandles;
  List<CandleData>? get oiCandles => _oiCandles;

  OhlcvPerIntervalModel? _lastOhlcv;
  OhlcvPerIntervalModel? get lastOhlcv => _lastOhlcv;

  CandlestickOiModel? _lastOi;
  CandlestickOiModel? get lastOi => _lastOi;

  String _symbol = 'BTCUSDT_PERP.A';
  String get symbol => _symbol;

  String _displayName = 'BTC/USDT Perp';
  String get displayName => _displayName;

  TimeInterval _interval = TimeInterval.oneHour;
  TimeInterval get interval => _interval;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Changes the symbol and display name, then reloads data.
  void setSymbol(String symbol, String displayName) {
    _symbol = symbol;
    _displayName = displayName;
    loadData();
  }

  /// Changes the time interval and reloads data.
  void setInterval(TimeInterval interval) {
    _interval = interval;
    loadData();
  }

  /// Fetches OHLCV and Open Interest data from the repository.
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final to = now.millisecondsSinceEpoch ~/ 1000;
      final from = to - _getFromDuration();

      final results = await Future.wait([
        _repository.getOhlcvHistory(
          symbols: _symbol,
          interval: _interval,
          from: from,
          to: to,
        ),
        _repository.getOpenInterestHistory(
          symbols: _symbol,
          interval: _interval,
          from: from,
          to: to,
          convertToUsd: true,
        ),
      ]);

      final ohlcvList = results[0] as List<OhlcvHistoryModel>;
      final oiList = results[1] as List<OpenInterestHistoryModel>;

      final ohlcvHistory =
          ohlcvList.isNotEmpty ? ohlcvList.first.history : null;
      final oiHistory = oiList.isNotEmpty ? oiList.first.history : null;

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

      _oiCandles = oiHistory?.map((e) {
        return CandleData(
          timestamp: (e.t ?? 0) * 1000,
          open: e.o,
          high: e.h,
          low: e.l,
          close: e.c,
          volume: 0,
        );
      }).toList();

      _lastOhlcv =
          ohlcvHistory?.isNotEmpty == true ? ohlcvHistory!.last : null;
      _lastOi = oiHistory?.isNotEmpty == true ? oiHistory!.last : null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e;
      _isLoading = false;
      notifyListeners();
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
}
