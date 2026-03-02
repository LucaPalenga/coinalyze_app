import '../../core/constants/api_constants.dart';
import '../../domain/repositories/coinalyze_repository.dart';
import '../datasources/coinalyze_remote_datasource.dart';
import '../models/models.dart';

/// Concrete implementation of [CoinalyzeRepository].
///
/// Delegates every call to [CoinalyzeRemoteDataSource].
/// Future enhancements (caching, offline support) go here.
class CoinalyzeRepositoryImpl implements CoinalyzeRepository {
  final CoinalyzeRemoteDataSource remoteDataSource;

  CoinalyzeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ExchangeInfoModel>> getExchanges() =>
      remoteDataSource.getExchanges();

  @override
  Future<List<FutureMarketInfoModel>> getFutureMarkets() =>
      remoteDataSource.getFutureMarkets();

  @override
  Future<List<SpotMarketInfoModel>> getSpotMarkets() =>
      remoteDataSource.getSpotMarkets();

  @override
  Future<List<OpenInterestModel>> getOpenInterest({
    required String symbols,
    bool convertToUsd = false,
  }) =>
      remoteDataSource.getOpenInterest(
        symbols: symbols,
        convertToUsd: convertToUsd,
      );

  @override
  Future<List<FundingRateModel>> getFundingRate({
    required String symbols,
  }) =>
      remoteDataSource.getFundingRate(symbols: symbols);

  @override
  Future<List<PredictedFundingRateModel>> getPredictedFundingRate({
    required String symbols,
  }) =>
      remoteDataSource.getPredictedFundingRate(symbols: symbols);

  @override
  Future<List<OpenInterestHistoryModel>> getOpenInterestHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  }) =>
      remoteDataSource.getOpenInterestHistory(
        symbols: symbols,
        interval: interval,
        from: from,
        to: to,
        convertToUsd: convertToUsd,
      );

  @override
  Future<List<FundingRateHistoryModel>> getFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) =>
      remoteDataSource.getFundingRateHistory(
        symbols: symbols,
        interval: interval,
        from: from,
        to: to,
      );

  @override
  Future<List<PredictedFundingRateHistoryModel>>
      getPredictedFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) =>
      remoteDataSource.getPredictedFundingRateHistory(
        symbols: symbols,
        interval: interval,
        from: from,
        to: to,
      );

  @override
  Future<List<LiquidationHistoryModel>> getLiquidationHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  }) =>
      remoteDataSource.getLiquidationHistory(
        symbols: symbols,
        interval: interval,
        from: from,
        to: to,
        convertToUsd: convertToUsd,
      );

  @override
  Future<List<LongShortRatioHistoryModel>> getLongShortRatioHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) =>
      remoteDataSource.getLongShortRatioHistory(
        symbols: symbols,
        interval: interval,
        from: from,
        to: to,
      );

  @override
  Future<List<OhlcvHistoryModel>> getOhlcvHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) =>
      remoteDataSource.getOhlcvHistory(
        symbols: symbols,
        interval: interval,
        from: from,
        to: to,
      );
}
