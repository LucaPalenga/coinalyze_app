import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

/// API error response.
@JsonSerializable()
class ApiErrorModel {
  /// The error message.
  final String? message;

  const ApiErrorModel({this.message});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}
