import 'package:json_annotation/json_annotation.dart';

part 'future_market_info_model.g.dart';

/// Represents a supported future market.
@JsonSerializable(fieldRename: FieldRename.snake)
class FutureMarketInfoModel {
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

  /// Whether the contract is perpetual.
  final bool? isPerpetual;

  /// Margin type: STABLE or COIN.
  final String? margined;

  /// Expiration UNIX timestamp in milliseconds (null for perpetuals).
  final int? expireAt;

  /// The asset OI, liquidation and volume is denominated in.
  final String? oiLqVolDenominatedIn;

  /// Whether the market has long/short ratio data.
  final bool? hasLongShortRatioData;

  /// Whether the market has OHLCV data.
  final bool? hasOhlcvData;

  /// Whether the market has buy/sell volume and trades count.
  final bool? hasBuySellData;

  const FutureMarketInfoModel({
    this.symbol,
    this.exchange,
    this.symbolOnExchange,
    this.baseAsset,
    this.quoteAsset,
    this.isPerpetual,
    this.margined,
    this.expireAt,
    this.oiLqVolDenominatedIn,
    this.hasLongShortRatioData,
    this.hasOhlcvData,
    this.hasBuySellData,
  });

  factory FutureMarketInfoModel.fromJson(Map<String, dynamic> json) =>
      _$FutureMarketInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$FutureMarketInfoModelToJson(this);
}
