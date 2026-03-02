import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';

import '../../core/constants/api_constants.dart';
import '../../data/models/models.dart';
import '../../data/datasources/coinalyze_remote_datasource.dart';
import '../../data/repositories/coinalyze_repository_impl.dart';
import '../../domain/repositories/coinalyze_repository.dart';
import 'package:http/http.dart' as http;

/// Main screen showing OHLCV price chart + Open Interest chart
/// stacked vertically, similar to the Coinalyze/TradingView layout.
class AssetChartScreen extends StatefulWidget {
  const AssetChartScreen({super.key});

  @override
  State<AssetChartScreen> createState() => _AssetChartScreenState();
}

class _AssetChartScreenState extends State<AssetChartScreen> {
  late final CoinalyzeRepository _repository;

  List<CandleData>? _ohlcvCandles;
  List<CandleData>? _oiCandles;

  bool _isLoading = true;
  String? _errorMessage;

  // Default symbol
  final String _symbol = 'BTCUSDT_PERP.A';
  final String _displayName = 'BTC/USDT Perp';

  // Default interval
  TimeInterval _interval = TimeInterval.oneHour;

  // OHLCV header info
  OhlcvPerIntervalModel? _lastOhlcv;
  CandlestickOiModel? _lastOi;

  @override
  void initState() {
    super.initState();
    _repository = CoinalyzeRepositoryImpl(
      remoteDataSource: CoinalyzeRemoteDataSourceImpl(client: http.Client()),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final now = DateTime.now();
      final to = now.millisecondsSinceEpoch ~/ 1000;

      // Calculate "from" based on interval
      final fromDuration = _getFromDuration();
      final from = to - fromDuration;

      // Fetch OHLCV and OI history in parallel
      final results = await Future.wait([
        _repository.getOhlcvHistory(symbols: _symbol, interval: _interval, from: from, to: to),
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

      final ohlcvHistory = ohlcvList.isNotEmpty ? ohlcvList.first.history : null;
      final oiHistory = oiList.isNotEmpty ? oiList.first.history : null;

      // Convert to CandleData for the chart
      final ohlcvCandles = ohlcvHistory?.map((e) {
        return CandleData(
          timestamp: (e.t ?? 0) * 1000, // convert seconds to ms
          open: e.o,
          high: e.h,
          low: e.l,
          close: e.c,
          volume: e.v,
        );
      }).toList();

      final oiCandles = oiHistory?.map((e) {
        return CandleData(
          timestamp: (e.t ?? 0) * 1000,
          open: e.o,
          high: e.h,
          low: e.l,
          close: e.c,
          volume: 0,
        );
      }).toList();

      setState(() {
        _ohlcvCandles = ohlcvCandles;
        _oiCandles = oiCandles;
        _lastOhlcv = ohlcvHistory?.isNotEmpty == true ? ohlcvHistory!.last : null;
        _lastOi = oiHistory?.isNotEmpty == true ? oiHistory!.last : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  int _getFromDuration() {
    // Returns number of seconds to look back based on interval
    switch (_interval) {
      case TimeInterval.oneMin:
        return 6 * 3600; // 6 hours
      case TimeInterval.fiveMin:
        return 24 * 3600; // 1 day
      case TimeInterval.fifteenMin:
        return 3 * 24 * 3600; // 3 days
      case TimeInterval.thirtyMin:
        return 5 * 24 * 3600; // 5 days
      case TimeInterval.oneHour:
        return 14 * 24 * 3600; // 14 days
      case TimeInterval.twoHour:
        return 21 * 24 * 3600; // 21 days
      case TimeInterval.fourHour:
        return 30 * 24 * 3600; // 30 days
      case TimeInterval.sixHour:
        return 45 * 24 * 3600; // 45 days
      case TimeInterval.twelveHour:
        return 90 * 24 * 3600; // 90 days
      case TimeInterval.daily:
        return 180 * 24 * 3600; // 180 days
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131722),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E222D),
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.currency_bitcoin, color: Color(0xFFF7931A), size: 24),
          const SizedBox(width: 8),
          Text(
            _displayName,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          _buildIntervalChip(),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white70),
          onPressed: _loadData,
        ),
      ],
    );
  }

  Widget _buildIntervalChip() {
    return PopupMenuButton<TimeInterval>(
      color: const Color(0xFF1E222D),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2E39),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_interval.value, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 16),
          ],
        ),
      ),
      onSelected: (interval) {
        setState(() => _interval = interval);
        _loadData();
      },
      itemBuilder: (context) => TimeInterval.values.map((interval) {
        return PopupMenuItem(
          value: interval,
          child: Text(
            interval.value,
            style: TextStyle(
              color: interval == _interval ? const Color(0xFF2962FF) : Colors.white70,
              fontWeight: interval == _interval ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF2962FF)));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                'Errore nel caricamento dei dati',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2962FF)),
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Riprova'),
              ),
            ],
          ),
        ),
      );
    }

    if (_ohlcvCandles == null || _ohlcvCandles!.isEmpty) {
      return const Center(
        child: Text('Nessun dato disponibile', style: TextStyle(color: Colors.white54)),
      );
    }

    return Column(
      children: [
        // OHLCV header info
        _buildOhlcvHeader(),
        // OHLCV price chart (top, ~65%)
        Expanded(flex: 65, child: _buildPriceChart()),
        // Divider
        Container(height: 1, color: const Color(0xFF2A2E39)),
        // OI header info
        _buildOiHeader(),
        // Open Interest chart (bottom, ~35%)
        Expanded(flex: 35, child: _buildOiChart()),
      ],
    );
  }

  Widget _buildOhlcvHeader() {
    if (_lastOhlcv == null) return const SizedBox.shrink();

    final o = _lastOhlcv!.o;
    final h = _lastOhlcv!.h;
    final l = _lastOhlcv!.l;
    final c = _lastOhlcv!.c;
    final change = (o != null && c != null) ? c - o : null;
    final changePct = (o != null && c != null && o != 0) ? ((c - o) / o) * 100 : null;
    final isPositive = (change ?? 0) >= 0;

    return Container(
      color: const Color(0xFF131722),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(
            '$_displayName  ${_interval.value}  Coinalyze',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(width: 12),
          _infoLabel('O', o, isPositive),
          _infoLabel('H', h, isPositive),
          _infoLabel('L', l, isPositive),
          _infoLabel('C', c, isPositive),
          if (change != null && changePct != null)
            Text(
              '  ${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)} (${changePct.toStringAsFixed(2)}%)',
              style: TextStyle(
                color: isPositive ? const Color(0xFF26A69A) : const Color(0xFFEF5350),
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoLabel(String label, double? value, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            TextSpan(
              text: value?.toStringAsFixed(2) ?? '-',
              style: TextStyle(
                color: isPositive ? const Color(0xFF26A69A) : const Color(0xFFEF5350),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOiHeader() {
    if (_lastOi == null) return const SizedBox.shrink();

    final o = _lastOi!.o;
    final h = _lastOi!.h;
    final l = _lastOi!.l;
    final c = _lastOi!.c;

    String formatBillions(double? val) {
      if (val == null) return '-';
      if (val >= 1e9) return '${(val / 1e9).toStringAsFixed(2)}B';
      if (val >= 1e6) return '${(val / 1e6).toStringAsFixed(2)}M';
      if (val >= 1e3) return '${(val / 1e3).toStringAsFixed(2)}K';
      return val.toStringAsFixed(2);
    }

    return Container(
      color: const Color(0xFF131722),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          const Text(
            'Aggregated Open Interest',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(width: 12),
          Text(
            '${formatBillions(o)}  ${formatBillions(h)}  ${formatBillions(l)}  ${formatBillions(c)}',
            style: const TextStyle(color: Color(0xFF26A69A), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChart() {
    return InteractiveChart(
      candles: _ohlcvCandles!,
      style: ChartStyle(
        priceGainColor: const Color(0xFF26A69A),
        priceLossColor: const Color(0xFFEF5350),
        volumeColor: const Color(0xFF26A69A).withValues(alpha: 0.3),
        priceGridLineColor: const Color(0xFF2A2E39),
        priceLabelStyle: const TextStyle(color: Colors.white38, fontSize: 10),
        timeLabelStyle: const TextStyle(color: Colors.white38, fontSize: 10),
        selectionHighlightColor: Colors.white.withValues(alpha: 0.05),
        overlayBackgroundColor: const Color(0xFF1E222D).withValues(alpha: 0.95),
        overlayTextStyle: const TextStyle(color: Colors.white70, fontSize: 11),
        volumeHeightFactor: 0.15,
      ),
      timeLabel: (timestamp, visibleDataCount) {
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (visibleDataCount > 120) {
          return DateFormat('MMM d').format(date);
        } else if (visibleDataCount > 60) {
          return DateFormat('d MMM').format(date);
        } else {
          return DateFormat('d MMM HH:mm').format(date);
        }
      },
      priceLabel: (price) => price.toStringAsFixed(2),
      overlayInfo: (candle) => {
        'Open': candle.open?.toStringAsFixed(2) ?? '-',
        'High': candle.high?.toStringAsFixed(2) ?? '-',
        'Low': candle.low?.toStringAsFixed(2) ?? '-',
        'Close': candle.close?.toStringAsFixed(2) ?? '-',
        'Volume': _formatVolume(candle.volume),
      },
    );
  }

  Widget _buildOiChart() {
    if (_oiCandles == null || _oiCandles!.isEmpty) {
      return const Center(
        child: Text(
          'Open Interest non disponibile',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      );
    }

    return InteractiveChart(
      candles: _oiCandles!,
      style: ChartStyle(
        priceGainColor: const Color(0xFF26A69A),
        priceLossColor: const Color(0xFFEF5350),
        volumeColor: Colors.transparent,
        priceGridLineColor: const Color(0xFF2A2E39),
        priceLabelStyle: const TextStyle(color: Colors.white38, fontSize: 10),
        timeLabelStyle: const TextStyle(color: Colors.white38, fontSize: 10),
        selectionHighlightColor: Colors.white.withValues(alpha: 0.05),
        overlayBackgroundColor: const Color(0xFF1E222D).withValues(alpha: 0.95),
        overlayTextStyle: const TextStyle(color: Colors.white70, fontSize: 11),
        volumeHeightFactor: 0.0,
      ),
      timeLabel: (timestamp, visibleDataCount) {
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (visibleDataCount > 120) {
          return DateFormat('MMM d').format(date);
        } else if (visibleDataCount > 60) {
          return DateFormat('d MMM').format(date);
        } else {
          return DateFormat('d MMM HH:mm').format(date);
        }
      },
      priceLabel: (price) {
        if (price >= 1e9) return '${(price / 1e9).toStringAsFixed(1)}B';
        if (price >= 1e6) return '${(price / 1e6).toStringAsFixed(1)}M';
        if (price >= 1e3) return '${(price / 1e3).toStringAsFixed(1)}K';
        return price.toStringAsFixed(0);
      },
      overlayInfo: (candle) => {
        'Open': _formatBillions(candle.open),
        'High': _formatBillions(candle.high),
        'Low': _formatBillions(candle.low),
        'Close': _formatBillions(candle.close),
      },
    );
  }

  String _formatVolume(double? vol) {
    if (vol == null) return '-';
    if (vol >= 1e9) return '${(vol / 1e9).toStringAsFixed(2)}B';
    if (vol >= 1e6) return '${(vol / 1e6).toStringAsFixed(2)}M';
    if (vol >= 1e3) return '${(vol / 1e3).toStringAsFixed(2)}K';
    return vol.toStringAsFixed(2);
  }

  String _formatBillions(double? val) {
    if (val == null) return '-';
    if (val >= 1e9) return '${(val / 1e9).toStringAsFixed(3)}B';
    if (val >= 1e6) return '${(val / 1e6).toStringAsFixed(2)}M';
    if (val >= 1e3) return '${(val / 1e3).toStringAsFixed(2)}K';
    return val.toStringAsFixed(2);
  }
}
