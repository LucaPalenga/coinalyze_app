import 'package:json_annotation/json_annotation.dart';

part 'liquidation_model.g.dart';

/// Liquidation volume per interval.
@JsonSerializable()
class LiquidationPerIntervalModel {
  /// The beginning of the interval, UNIX timestamp in seconds.
  final int? t;

  /// Longs liquidation volume.
  final double? l;

  /// Shorts liquidation volume.
  final double? s;

  const LiquidationPerIntervalModel({this.t, this.l, this.s});

  factory LiquidationPerIntervalModel.fromJson(Map<String, dynamic> json) =>
      _$LiquidationPerIntervalModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiquidationPerIntervalModelToJson(this);
}

/// Liquidation history for a symbol.
@JsonSerializable()
class LiquidationHistoryModel {
  /// Market symbol.
  final String? symbol;

  /// List of liquidation data points.
  final List<LiquidationPerIntervalModel>? history;

  const LiquidationHistoryModel({this.symbol, this.history});

  factory LiquidationHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$LiquidationHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiquidationHistoryModelToJson(this);
}
