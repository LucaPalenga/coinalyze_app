import 'package:json_annotation/json_annotation.dart';

part 'open_interest_model.g.dart';

/// Current open interest for a symbol.
@JsonSerializable()
class OpenInterestModel {
  /// Market symbol.
  final String? symbol;

  /// Current open interest value.
  final double? value;

  /// UNIX timestamp in milliseconds.
  final int? update;

  const OpenInterestModel({this.symbol, this.value, this.update});

  factory OpenInterestModel.fromJson(Map<String, dynamic> json) =>
      _$OpenInterestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenInterestModelToJson(this);
}
