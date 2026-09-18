import '../error/error_mapper.dart';

/// Base exception cho tất cả API errors
class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  
  ApiException(this.message, {this.code, this.statusCode});
  
  /// Thông báo lỗi thân thiện dành cho giao diện người dùng
  String get userMessage => ErrorMapper.map(code, defaultMessage: message);

  @override
  String toString() => 'ApiException: $message (code: $code, status: $statusCode)';
}

/// Network connectivity errors (timeout, no internet)
class NetworkException extends ApiException {
  NetworkException(super.message, {String? code}) 
      : super(code: code ?? 'NETWORK_ERROR');
}

/// Server-side errors (4xx, 5xx responses)
class ServerException extends ApiException {
  ServerException(super.message, int statusCode, {String? code}) 
      : super(code: code ?? 'SERVER_ERROR', statusCode: statusCode);
}

/// Authentication/Authorization errors
class AuthException extends ApiException {
  AuthException(super.message, int statusCode, {String? code})
      : super(code: code ?? 'AUTH_ERROR', statusCode: statusCode);
}
