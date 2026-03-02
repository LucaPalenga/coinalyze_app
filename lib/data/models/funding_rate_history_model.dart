import 'package:json_annotation/json_annotation.dart';

import 'candlestick_model.dart';

part 'funding_rate_history_model.g.dart';

/// Funding rate history for a symbol.
@JsonSerializable()
class FundingRateHistoryModel {
  /// Market symbol.
  final String? symbol;

  /// List of funding rate candlestick data points.
  final List<CandlestickFrModel>? history;

  const FundingRateHistoryModel({this.symbol, this.history});

  factory FundingRateHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$FundingRateHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$FundingRateHistoryModelToJson(this);
}
