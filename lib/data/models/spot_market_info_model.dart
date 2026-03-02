import 'package:json_annotation/json_annotation.dart';

part 'spot_market_info_model.g.dart';

/// Represents a supported spot market.
@JsonSerializable(fieldRename: FieldRename.snake)
class SpotMarketInfoModel {
  /// Market symbol.
  final String? symbol;

  /// Exchange code.
  final String? exchange;

  /// Symbol on the exchange.
  final String? symbolOnExchange;

  /// Base asset.
  final String? baseAsset;

  /// Quote asset.
  final String? quoteAsset;

  /// Whether the market has buy/sell volume and trades count.
  final bool? hasBuySellData;

  const SpotMarketInfoModel({
    this.symbol,
    this.exchange,
    this.symbolOnExchange,
    this.baseAsset,
    this.quoteAsset,
    this.hasBuySellData,
  });

  factory SpotMarketInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SpotMarketInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpotMarketInfoModelToJson(this);
}
