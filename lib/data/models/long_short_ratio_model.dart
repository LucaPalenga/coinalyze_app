import 'package:json_annotation/json_annotation.dart';

part 'long_short_ratio_model.g.dart';

/// Long/short ratio per interval.
@JsonSerializable()
class LongShortRatioPerIntervalModel {
  /// The beginning of the interval, UNIX timestamp in seconds.
  final int? t;

  /// Ratio.
  final double? r;

  /// Longs %.
  final double? l;

  /// Shorts %.
  final double? s;

  const LongShortRatioPerIntervalModel({this.t, this.r, this.l, this.s});

  factory LongShortRatioPerIntervalModel.fromJson(
          Map<String, dynamic> json) =>
      _$LongShortRatioPerIntervalModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LongShortRatioPerIntervalModelToJson(this);
}

/// Long/short ratio history for a symbol.
@JsonSerializable()
class LongShortRatioHistoryModel {
  /// Market symbol.
  final String? symbol;

  /// List of long/short ratio data points.
  final List<LongShortRatioPerIntervalModel>? history;

  const LongShortRatioHistoryModel({this.symbol, this.history});

  factory LongShortRatioHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$LongShortRatioHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LongShortRatioHistoryModelToJson(this);
}
