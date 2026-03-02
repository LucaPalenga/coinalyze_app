import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
// ignore: implementation_imports
import 'package:interactive_chart/src/chart_painter.dart';
// ignore: implementation_imports
import 'package:interactive_chart/src/painter_params.dart';
import 'package:intl/intl.dart' as intl;

/// Controller that keeps two or more [SyncedInteractiveChart]s
/// scrolled and zoomed to the same position.
class ChartScrollController extends ChangeNotifier {
  double _candleWidth = 0;
  double _startOffset = 0;
  bool _initialized = false;

  double get candleWidth => _candleWidth;
  double get startOffset => _startOffset;
  bool get initialized => _initialized;

  void update(double candleWidth, double startOffset) {
    if (_candleWidth == candleWidth && _startOffset == startOffset) return;
    _candleWidth = candleWidth;
    _startOffset = startOffset;
    _initialized = true;
    notifyListeners();
  }
}

/// A fork of [InteractiveChart] that synchronises pan/zoom
/// with other chart instances through a shared [ChartScrollController].
///
/// The source chart (the one the user is interacting with) writes to the
/// controller; follower charts read from it.
class SyncedInteractiveChart extends StatefulWidget {
  final List<CandleData> candles;
  final int initialVisibleCandleCount;
  final ChartStyle style;
  final String Function(int timestamp, int visibleDataCount)? timeLabel;
  final String Function(double price)? priceLabel;
  final Map<String, String> Function(CandleData candle)? overlayInfo;
  final ValueChanged<CandleData>? onTap;
  final ValueChanged<double>? onCandleResize;
  final ChartScrollController? scrollController;

  const SyncedInteractiveChart({
    super.key,
    required this.candles,
    this.initialVisibleCandleCount = 90,
    ChartStyle? style,
    this.timeLabel,
    this.priceLabel,
    this.overlayInfo,
    this.onTap,
    this.onCandleResize,
    this.scrollController,
  }) : style = style ?? const ChartStyle(),
       assert(candles.length >= 3, 'SyncedInteractiveChart requires 3 or more CandleData'),
       assert(initialVisibleCandleCount >= 3, 'initialVisibleCandleCount must be 3 or more');

  @override
  State<SyncedInteractiveChart> createState() => _SyncedInteractiveChartState();
}

class _SyncedInteractiveChartState extends State<SyncedInteractiveChart> {
  late double _candleWidth;
  late double _startOffset;

  Offset? _tapPosition;

  double? _prevChartWidth;
  late double _prevCandleWidth;
  late double _prevStartOffset;
  late Offset _initialFocalPoint;

  /// True while *this* widget is the source of a gesture.
  bool _isSelfDriven = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SyncedInteractiveChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_onControllerUpdate);
      widget.scrollController?.addListener(_onControllerUpdate);
    }
    // If candle data changed, reset chart width cache so _handleResize runs
    if (oldWidget.candles != widget.candles) {
      _prevChartWidth = null;
    }
  }

  void _onControllerUpdate() {
    if (_isSelfDriven) return;
    final ctrl = widget.scrollController;
    if (ctrl == null || !ctrl.initialized) return;
    if (ctrl.candleWidth == _candleWidth && ctrl.startOffset == _startOffset) return;
    setState(() {
      _candleWidth = ctrl.candleWidth;
      _startOffset = _clampOffset(ctrl.startOffset, _prevChartWidth ?? 0, ctrl.candleWidth);
    });
  }

  double _clampOffset(double offset, double w, double cw) {
    return offset.clamp(0.0, _getMaxStartOffset(w, cw));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = constraints.biggest;
        final w = size.width - widget.style.priceLabelWidth;
        _handleResize(w);

        final int start = (_startOffset / _candleWidth).floor();
        final int count = (w / _candleWidth).ceil();
        final int end = (start + count).clamp(start, widget.candles.length);
        final candlesInRange = widget.candles.getRange(start, end).toList();
        if (end < widget.candles.length) {
          candlesInRange.add(widget.candles[end]);
        }

        final leadingTrends = _safeAt(widget.candles, start - 1)?.trends;
        final trailingTrends = _safeAt(widget.candles, end + 1)?.trends;

        final halfCandle = _candleWidth / 2;
        final fractionCandle = _startOffset - start * _candleWidth;
        final xShift = halfCandle - fractionCandle;

        double? highest(CandleData c) {
          if (c.high != null) return c.high;
          if (c.open != null && c.close != null) return max(c.open!, c.close!);
          return c.open ?? c.close;
        }

        double? lowest(CandleData c) {
          if (c.low != null) return c.low;
          if (c.open != null && c.close != null) return min(c.open!, c.close!);
          return c.open ?? c.close;
        }

        final maxPrice = candlesInRange.map(highest).whereType<double>().reduce(max);
        final minPrice = candlesInRange.map(lowest).whereType<double>().reduce(min);
        final maxVol = candlesInRange
            .map((c) => c.volume)
            .whereType<double>()
            .fold(double.negativeInfinity, max);
        final minVol = candlesInRange
            .map((c) => c.volume)
            .whereType<double>()
            .fold(double.infinity, min);

        final child = TweenAnimationBuilder(
          tween: PainterParamsTween(
            end: PainterParams(
              candles: candlesInRange,
              style: widget.style,
              size: size,
              candleWidth: _candleWidth,
              startOffset: _startOffset,
              maxPrice: maxPrice,
              minPrice: minPrice,
              maxVol: maxVol,
              minVol: minVol,
              xShift: xShift,
              tapPosition: _tapPosition,
              leadingTrends: leadingTrends,
              trailingTrends: trailingTrends,
            ),
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (_, PainterParams params, _) {
            return RepaintBoundary(
              child: CustomPaint(
                size: size,
                painter: ChartPainter(
                  params: params,
                  getTimeLabel: widget.timeLabel ?? _defaultTimeLabel,
                  getPriceLabel: widget.priceLabel ?? _defaultPriceLabel,
                  getOverlayInfo: widget.overlayInfo ?? _defaultOverlayInfo,
                ),
              ),
            );
          },
        );

        return Listener(
          onPointerSignal: (signal) {
            if (signal is PointerScrollEvent) {
              final dy = signal.scrollDelta.dy;
              if (dy.abs() > 0) {
                _onScaleStart(signal.position);
                _onScaleUpdate(dy > 0 ? 0.9 : 1.1, signal.position, w);
              }
            }
          },
          child: GestureDetector(
            onTapDown: (d) => setState(() => _tapPosition = d.localPosition),
            onTapCancel: () => setState(() => _tapPosition = null),
            onTapUp: (_) => setState(() => _tapPosition = null),
            onScaleStart: (d) => _onScaleStart(d.localFocalPoint),
            onScaleUpdate: (d) => _onScaleUpdate(d.scale, d.localFocalPoint, w),
            onScaleEnd: (_) => _isSelfDriven = false,
            child: child,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Gesture handling (identical to interactive_chart, plus controller sync)
  // ---------------------------------------------------------------------------

  void _onScaleStart(Offset focalPoint) {
    _isSelfDriven = true;
    _prevCandleWidth = _candleWidth;
    _prevStartOffset = _startOffset;
    _initialFocalPoint = focalPoint;
  }

  void _onScaleUpdate(double scale, Offset focalPoint, double w) {
    final candleWidth = (_prevCandleWidth * scale).clamp(
      _getMinCandleWidth(w),
      _getMaxCandleWidth(w),
    );
    final clampedScale = candleWidth / _prevCandleWidth;
    var startOffset = _prevStartOffset * clampedScale;
    final dx = (focalPoint - _initialFocalPoint).dx * -1;
    startOffset += dx;
    final double prevCount = w / _prevCandleWidth;
    final double currCount = w / candleWidth;
    final zoomAdjustment = (currCount - prevCount) * candleWidth;
    final focalPointFactor = focalPoint.dx / w;
    startOffset -= zoomAdjustment * focalPointFactor;
    startOffset = startOffset.clamp(0.0, _getMaxStartOffset(w, candleWidth));

    if (candleWidth != _candleWidth) {
      widget.onCandleResize?.call(candleWidth);
    }

    setState(() {
      _candleWidth = candleWidth;
      _startOffset = startOffset;
    });

    widget.scrollController?.update(candleWidth, startOffset);
  }

  void _handleResize(double w) {
    if (w == _prevChartWidth) return;
    final ctrl = widget.scrollController;
    if (_prevChartWidth != null) {
      _candleWidth = _candleWidth.clamp(_getMinCandleWidth(w), _getMaxCandleWidth(w));
      _startOffset = _startOffset.clamp(0, _getMaxStartOffset(w, _candleWidth));
    } else if (ctrl != null && ctrl.initialized) {
      _candleWidth = ctrl.candleWidth.clamp(_getMinCandleWidth(w), _getMaxCandleWidth(w));
      _startOffset = ctrl.startOffset.clamp(0, _getMaxStartOffset(w, _candleWidth));
    } else {
      final visCount = min(widget.candles.length, widget.initialVisibleCandleCount);
      _candleWidth = w / visCount;
      _startOffset = (widget.candles.length - visCount) * _candleWidth;
    }
    _prevChartWidth = w;
  }

  double _getMinCandleWidth(double w) => w / widget.candles.length;
  double _getMaxCandleWidth(double w) => w / min(14, widget.candles.length);

  double _getMaxStartOffset(double w, double candleWidth) {
    final count = w / candleWidth;
    final start = widget.candles.length - count;
    return max(0, candleWidth * start);
  }

  // ---------------------------------------------------------------------------
  // Default formatters
  // ---------------------------------------------------------------------------

  String _defaultTimeLabel(int timestamp, int visibleDataCount) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      timestamp,
    ).toIso8601String().split('T').first.split('-');
    if (visibleDataCount > 20) return '${date[0]}-${date[1]}';
    return '${date[1]}-${date[2]}';
  }

  String _defaultPriceLabel(double price) => price.toStringAsFixed(2);

  Map<String, String> _defaultOverlayInfo(CandleData candle) {
    final date = intl.DateFormat.yMMMd().format(
      DateTime.fromMillisecondsSinceEpoch(candle.timestamp),
    );
    return {
      'Date': date,
      'Open': candle.open?.toStringAsFixed(2) ?? '-',
      'High': candle.high?.toStringAsFixed(2) ?? '-',
      'Low': candle.low?.toStringAsFixed(2) ?? '-',
      'Close': candle.close?.toStringAsFixed(2) ?? '-',
      'Volume': candle.volume?.toStringAsFixed(0) ?? '-',
    };
  }

  /// Nullable-safe list access to avoid extension conflicts.
  static T? _safeAt<T>(List<T> list, int index) =>
      (index >= 0 && index < list.length) ? list[index] : null;
}
