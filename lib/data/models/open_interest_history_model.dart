import 'package:json_annotation/json_annotation.dart';

import 'candlestick_model.dart';

part 'open_interest_history_model.g.dart';

/// Open interest history for a symbol.
@JsonSerializable()
class OpenInterestHistoryModel {
  /// Market symbol.
  final String? symbol;

  /// List of OI candlestick data points.
  final List<CandlestickOiModel>? history;

  const OpenInterestHistoryModel({this.symbol, this.history});

  factory OpenInterestHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$OpenInterestHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenInterestHistoryModelToJson(this);
}
