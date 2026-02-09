/// Base exception cho tất cả API errors
class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  
  ApiException(this.message, {this.code, this.statusCode});
  
  @override
  String toString() => 'ApiException: $message (code: $code, status: $statusCode)';
}

/// Network connectivity errors (timeout, no internet)
class NetworkException extends ApiException {
  NetworkException(String message, {String? code}) 
      : super(message, code: code ?? 'NETWORK_ERROR');
}

/// Server-side errors (4xx, 5xx responses)
class ServerException extends ApiException {
  ServerException(String message, int statusCode, {String? code}) 
      : super(message, code: code ?? 'SERVER_ERROR', statusCode: statusCode);
}

/// Authentication/Authorization errors
class AuthException extends ApiException {
  AuthException(String message, int statusCode, {String? code})
      : super(message, code: code ?? 'AUTH_ERROR', statusCode: statusCode);
}
