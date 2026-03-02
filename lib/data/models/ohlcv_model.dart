import 'package:json_annotation/json_annotation.dart';

part 'ohlcv_model.g.dart';

/// OHLCV data per interval.
@JsonSerializable()
class OhlcvPerIntervalModel {
  /// The beginning of the interval, UNIX timestamp in seconds.
  final int? t;

  /// Open price.
  final double? o;

  /// High price.
  final double? h;

  /// Low price.
  final double? l;

  /// Close price.
  final double? c;

  /// Total volume.
  final double? v;

  /// Buy volume. Sell volume = v - bv.
  final double? bv;

  /// Total trades.
  final double? tx;

  /// Buy trades. Sell trades = tx - btx.
  final double? btx;

  const OhlcvPerIntervalModel({
    this.t,
    this.o,
    this.h,
    this.l,
    this.c,
    this.v,
    this.bv,
    this.tx,
    this.btx,
  });

  factory OhlcvPerIntervalModel.fromJson(Map<String, dynamic> json) =>
      _$OhlcvPerIntervalModelFromJson(json);

  Map<String, dynamic> toJson() => _$OhlcvPerIntervalModelToJson(this);
}

/// OHLCV history for a symbol.
@JsonSerializable()
class OhlcvHistoryModel {
  /// Market symbol.
  final String? symbol;

  /// List of OHLCV data points.
  final List<OhlcvPerIntervalModel>? history;

  const OhlcvHistoryModel({this.symbol, this.history});

  factory OhlcvHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$OhlcvHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$OhlcvHistoryModelToJson(this);
}
