import 'package:json_annotation/json_annotation.dart';

part 'exchange_info_model.g.dart';

/// Represents a supported exchange.
@JsonSerializable(fieldRename: FieldRename.snake)
class ExchangeInfoModel {
  /// Exchange name.
  final String? name;

  /// Exchange code.
  final String? code;

  const ExchangeInfoModel({this.name, this.code});

  factory ExchangeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeInfoModelToJson(this);
}
