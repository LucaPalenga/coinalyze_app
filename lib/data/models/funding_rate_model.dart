import 'package:json_annotation/json_annotation.dart';

part 'funding_rate_model.g.dart';

/// Current funding rate for a symbol.
@JsonSerializable()
class FundingRateModel {
  /// Market symbol.
  final String? symbol;

  /// Current funding rate (%).
  final double? value;

  /// UNIX timestamp in milliseconds.
  final int? update;

  const FundingRateModel({this.symbol, this.value, this.update});

  factory FundingRateModel.fromJson(Map<String, dynamic> json) =>
      _$FundingRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$FundingRateModelToJson(this);
}
