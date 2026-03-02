import '../../core/constants/api_constants.dart';
import '../../data/models/models.dart';

/// Domain-layer contract for Coinalyze data access.
///
/// Presentation and use-case layers depend on this interface,
/// never on the concrete implementation.
abstract class CoinalyzeRepository {
  /// Returns the list of supported exchanges.
  Future<List<ExchangeInfoModel>> getExchanges();

  /// Returns the list of supported future markets.
  Future<List<FutureMarketInfoModel>> getFutureMarkets();

  /// Returns the list of supported spot markets.
  Future<List<SpotMarketInfoModel>> getSpotMarkets();

  /// Returns current open interest for the given [symbols].
  Future<List<OpenInterestModel>> getOpenInterest({
    required String symbols,
    bool convertToUsd = false,
  });

  /// Returns current funding rate for the given [symbols].
  Future<List<FundingRateModel>> getFundingRate({
    required String symbols,
  });

  /// Returns current predicted funding rate for the given [symbols].
  Future<List<PredictedFundingRateModel>> getPredictedFundingRate({
    required String symbols,
  });

  /// Returns open interest history for the given [symbols].
  Future<List<OpenInterestHistoryModel>> getOpenInterestHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  });

  /// Returns funding rate history for the given [symbols].
  Future<List<FundingRateHistoryModel>> getFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });

  /// Returns predicted funding rate history for the given [symbols].
  Future<List<PredictedFundingRateHistoryModel>>
      getPredictedFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });

  /// Returns liquidation history for the given [symbols].
  Future<List<LiquidationHistoryModel>> getLiquidationHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  });

  /// Returns long/short ratio history for the given [symbols].
  Future<List<LongShortRatioHistoryModel>> getLongShortRatioHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });

  /// Returns OHLCV history for the given [symbols].
  Future<List<OhlcvHistoryModel>> getOhlcvHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });
}
