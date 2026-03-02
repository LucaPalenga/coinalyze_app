/// Constants for the Coinalyze API.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.coinalyze.net/v1';

  // Endpoints
  static const String exchanges = '/exchanges';
  static const String futureMarkets = '/future-markets';
  static const String spotMarkets = '/spot-markets';
  static const String openInterest = '/open-interest';
  static const String fundingRate = '/funding-rate';
  static const String predictedFundingRate = '/predicted-funding-rate';
  static const String openInterestHistory = '/open-interest-history';
  static const String fundingRateHistory = '/funding-rate-history';
  static const String predictedFundingRateHistory = '/predicted-funding-rate-history';
  static const String liquidationHistory = '/liquidation-history';
  static const String longShortRatioHistory = '/long-short-ratio-history';
  static const String ohlcvHistory = '/ohlcv-history';

  // Query parameter keys
  static const String symbolsParam = 'symbols';
  static const String intervalParam = 'interval';
  static const String fromParam = 'from';
  static const String toParam = 'to';
  static const String convertToUsdParam = 'convert_to_usd';
  static const String apiKeyHeader = 'api_key';
}

/// Supported time intervals for history endpoints.
enum TimeInterval {
  oneMin('1min'),
  fiveMin('5min'),
  fifteenMin('15min'),
  thirtyMin('30min'),
  oneHour('1hour'),
  twoHour('2hour'),
  fourHour('4hour'),
  sixHour('6hour'),
  twelveHour('12hour'),
  daily('daily');

  final String value;
  const TimeInterval(this.value);
}
