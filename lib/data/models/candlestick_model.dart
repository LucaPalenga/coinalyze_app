import 'package:json_annotation/json_annotation.dart';

part 'candlestick_model.g.dart';

/// OHLC candlestick for open interest history.
@JsonSerializable()
class CandlestickOiModel {
  /// The beginning of the interval, UNIX timestamp in seconds.
  final int? t;

  /// Open interest at the beginning of the interval.
  final double? o;

  /// Highest open interest during the interval.
  final double? h;

  /// Lowest open interest during the interval.
  final double? l;

  /// Open interest at the end of the interval.
  final double? c;

  const CandlestickOiModel({this.t, this.o, this.h, this.l, this.c});

  factory CandlestickOiModel.fromJson(Map<String, dynamic> json) =>
      _$CandlestickOiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CandlestickOiModelToJson(this);
}

/// OHLC candlestick for funding rate history.
@JsonSerializable()
class CandlestickFrModel {
  /// The beginning of the interval, UNIX timestamp in seconds.
  final int? t;

  /// Funding rate at the beginning of the interval.
  final double? o;

  /// Highest funding rate during the interval.
  final double? h;

  /// Lowest funding rate during the interval.
  final double? l;

  /// Funding rate at the end of the interval.
  final double? c;

  const CandlestickFrModel({this.t, this.o, this.h, this.l, this.c});

  factory CandlestickFrModel.fromJson(Map<String, dynamic> json) =>
      _$CandlestickFrModelFromJson(json);

  Map<String, dynamic> toJson() => _$CandlestickFrModelToJson(this);
}

/// OHLC candlestick for predicted funding rate history.
@JsonSerializable()
class CandlestickPfrModel {
  /// The beginning of the interval, UNIX timestamp in seconds.
  final int? t;

  /// Predicted funding rate at the beginning of the interval.
  final double? o;

  /// Highest predicted funding rate during the interval.
  final double? h;

  /// Lowest predicted funding rate during the interval.
  final double? l;

  /// Predicted funding rate at the end of the interval.
  final double? c;

  const CandlestickPfrModel({this.t, this.o, this.h, this.l, this.c});

  factory CandlestickPfrModel.fromJson(Map<String, dynamic> json) =>
      _$CandlestickPfrModelFromJson(json);

  Map<String, dynamic> toJson() => _$CandlestickPfrModelToJson(this);
}
