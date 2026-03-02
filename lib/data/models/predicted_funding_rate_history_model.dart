import 'package:json_annotation/json_annotation.dart';

import 'candlestick_model.dart';

part 'predicted_funding_rate_history_model.g.dart';

/// Predicted funding rate history for a symbol.
@JsonSerializable()
class PredictedFundingRateHistoryModel {
  /// Market symbol.
  final String? symbol;

  /// List of predicted funding rate candlestick data points.
  final List<CandlestickPfrModel>? history;

  const PredictedFundingRateHistoryModel({this.symbol, this.history});

  factory PredictedFundingRateHistoryModel.fromJson(
          Map<String, dynamic> json) =>
      _$PredictedFundingRateHistoryModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PredictedFundingRateHistoryModelToJson(this);
}
