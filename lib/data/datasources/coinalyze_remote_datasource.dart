import 'dart:convert';

import 'package:coinalyze_app/core/config/env_config.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/models.dart';

/// Remote data source for the Coinalyze API.
///
/// Handles all HTTP communication with `https://api.coinalyze.net/v1`.
/// Each method maps 1-to-1 with an API endpoint and returns parsed model(s).
abstract class CoinalyzeRemoteDataSource {
  /// GET /exchanges
  Future<List<ExchangeInfoModel>> getExchanges();

  /// GET /future-markets
  Future<List<FutureMarketInfoModel>> getFutureMarkets();

  /// GET /spot-markets
  Future<List<SpotMarketInfoModel>> getSpotMarkets();

  /// GET /open-interest
  Future<List<OpenInterestModel>> getOpenInterest({
    required String symbols,
    bool convertToUsd = false,
  });

  /// GET /funding-rate
  Future<List<FundingRateModel>> getFundingRate({required String symbols});

  /// GET /predicted-funding-rate
  Future<List<PredictedFundingRateModel>> getPredictedFundingRate({required String symbols});

  /// GET /open-interest-history
  Future<List<OpenInterestHistoryModel>> getOpenInterestHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  });

  /// GET /funding-rate-history
  Future<List<FundingRateHistoryModel>> getFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });

  /// GET /predicted-funding-rate-history
  Future<List<PredictedFundingRateHistoryModel>> getPredictedFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });

  /// GET /liquidation-history
  Future<List<LiquidationHistoryModel>> getLiquidationHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  });

  /// GET /long-short-ratio-history
  Future<List<LongShortRatioHistoryModel>> getLongShortRatioHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });

  /// GET /ohlcv-history
  Future<List<OhlcvHistoryModel>> getOhlcvHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  });
}

/// Implementation of [CoinalyzeRemoteDataSource] using the `http` package.
class CoinalyzeRemoteDataSourceImpl implements CoinalyzeRemoteDataSource {
  final http.Client client;

  CoinalyzeRemoteDataSourceImpl({required this.client});

  // ---------------------------------------------------------------------------
  // Helper
  // ---------------------------------------------------------------------------

  Uri _buildUri(String path, [Map<String, String>? queryParams]) {
    final params = <String, String>{
      ApiConstants.apiKeyHeader: EnvConfig.coinalyzeApiKey,
      ...?queryParams,
    };
    return Uri.parse('${ApiConstants.baseUrl}$path').replace(queryParameters: params);
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        final error = ApiErrorModel.fromJson(json.decode(response.body));
        throw BadRequestException(message: error.message ?? 'Bad request');
      case 401:
        final error = ApiErrorModel.fromJson(json.decode(response.body));
        throw UnauthorizedException(message: error.message ?? 'Invalid/missing API key');
      case 429:
        final error = ApiErrorModel.fromJson(json.decode(response.body));
        throw RateLimitException(message: error.message ?? 'Too many requests');
      default:
        throw ServerException(
          message: 'Unexpected error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
    }
  }

  Future<dynamic> _get(String path, [Map<String, String>? queryParams]) async {
    final uri = _buildUri(path, queryParams);
    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Endpoints
  // ---------------------------------------------------------------------------

  @override
  Future<List<ExchangeInfoModel>> getExchanges() async {
    final data = await _get(ApiConstants.exchanges) as List;
    return data.map((e) => ExchangeInfoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<FutureMarketInfoModel>> getFutureMarkets() async {
    final data = await _get(ApiConstants.futureMarkets) as List;
    return data.map((e) => FutureMarketInfoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<SpotMarketInfoModel>> getSpotMarkets() async {
    final data = await _get(ApiConstants.spotMarkets) as List;
    return data.map((e) => SpotMarketInfoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<OpenInterestModel>> getOpenInterest({
    required String symbols,
    bool convertToUsd = false,
  }) async {
    final data =
        await _get(ApiConstants.openInterest, {
              ApiConstants.symbolsParam: symbols,
              if (convertToUsd) ApiConstants.convertToUsdParam: 'true',
            })
            as List;
    return data.map((e) => OpenInterestModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<FundingRateModel>> getFundingRate({required String symbols}) async {
    final data = await _get(ApiConstants.fundingRate, {ApiConstants.symbolsParam: symbols}) as List;
    return data.map((e) => FundingRateModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<PredictedFundingRateModel>> getPredictedFundingRate({required String symbols}) async {
    final data =
        await _get(ApiConstants.predictedFundingRate, {ApiConstants.symbolsParam: symbols}) as List;
    return data.map((e) => PredictedFundingRateModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<OpenInterestHistoryModel>> getOpenInterestHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  }) async {
    final data =
        await _get(ApiConstants.openInterestHistory, {
              ApiConstants.symbolsParam: symbols,
              ApiConstants.intervalParam: interval.value,
              ApiConstants.fromParam: from.toString(),
              ApiConstants.toParam: to.toString(),
              if (convertToUsd) ApiConstants.convertToUsdParam: 'true',
            })
            as List;
    return data.map((e) => OpenInterestHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<FundingRateHistoryModel>> getFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) async {
    final data =
        await _get(ApiConstants.fundingRateHistory, {
              ApiConstants.symbolsParam: symbols,
              ApiConstants.intervalParam: interval.value,
              ApiConstants.fromParam: from.toString(),
              ApiConstants.toParam: to.toString(),
            })
            as List;
    return data.map((e) => FundingRateHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<PredictedFundingRateHistoryModel>> getPredictedFundingRateHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) async {
    final data =
        await _get(ApiConstants.predictedFundingRateHistory, {
              ApiConstants.symbolsParam: symbols,
              ApiConstants.intervalParam: interval.value,
              ApiConstants.fromParam: from.toString(),
              ApiConstants.toParam: to.toString(),
            })
            as List;
    return data
        .map((e) => PredictedFundingRateHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<LiquidationHistoryModel>> getLiquidationHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
    bool convertToUsd = false,
  }) async {
    final data =
        await _get(ApiConstants.liquidationHistory, {
              ApiConstants.symbolsParam: symbols,
              ApiConstants.intervalParam: interval.value,
              ApiConstants.fromParam: from.toString(),
              ApiConstants.toParam: to.toString(),
              if (convertToUsd) ApiConstants.convertToUsdParam: 'true',
            })
            as List;
    return data.map((e) => LiquidationHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<LongShortRatioHistoryModel>> getLongShortRatioHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) async {
    final data =
        await _get(ApiConstants.longShortRatioHistory, {
              ApiConstants.symbolsParam: symbols,
              ApiConstants.intervalParam: interval.value,
              ApiConstants.fromParam: from.toString(),
              ApiConstants.toParam: to.toString(),
            })
            as List;
    return data.map((e) => LongShortRatioHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<OhlcvHistoryModel>> getOhlcvHistory({
    required String symbols,
    required TimeInterval interval,
    required int from,
    required int to,
  }) async {
    final data =
        await _get(ApiConstants.ohlcvHistory, {
              ApiConstants.symbolsParam: symbols,
              ApiConstants.intervalParam: interval.value,
              ApiConstants.fromParam: from.toString(),
              ApiConstants.toParam: to.toString(),
            })
            as List;
    return data.map((e) => OhlcvHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
