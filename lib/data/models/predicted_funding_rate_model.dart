import 'package:json_annotation/json_annotation.dart';

part 'predicted_funding_rate_model.g.dart';

/// Current predicted funding rate for a symbol.
@JsonSerializable()
class PredictedFundingRateModel {
  /// Market symbol.
  final String? symbol;

  /// Current predicted funding rate (%).
  final double? value;

  /// UNIX timestamp in milliseconds.
  final int? update;

  const PredictedFundingRateModel({this.symbol, this.value, this.update});

  factory PredictedFundingRateModel.fromJson(Map<String, dynamic> json) =>
      _$PredictedFundingRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$PredictedFundingRateModelToJson(this);
}
