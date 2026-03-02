/// Exception thrown when a server error occurs during API calls.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exception thrown when a bad request (400) is made.
class BadRequestException extends ServerException {
  const BadRequestException({required super.message}) : super(statusCode: 400);
}

/// Exception thrown when the API key is invalid or missing (401).
class UnauthorizedException extends ServerException {
  const UnauthorizedException({required super.message}) : super(statusCode: 401);
}

/// Exception thrown when too many requests are made (429).
class RateLimitException extends ServerException {
  const RateLimitException({required super.message}) : super(statusCode: 429);
}

/// Exception thrown when a network error occurs (no internet, DNS failure, timeout).
class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}
