/// Wrapper chung cho tất cả API responses từ backend
/// 
/// Format: 
/// {
///   "statusCode": 200,
///   "errorCode": null,  // null = success, có giá trị = có lỗi
///   "data": {...},
///   "traceId": "..."
/// }
class ApiResponse<T> {
  final int statusCode;
  final int? errorCode;
  final T? data;
  final String? traceId;

  ApiResponse({
    required this.statusCode,
    this.errorCode,
    this.data,
    this.traceId,
  });

  /// Kiểm tra xem response có thành công không
  /// Success khi (errorCode = null hoặc 0) và statusCode 2xx
  bool get isSuccess =>
      (errorCode == null || errorCode == 0) &&
      statusCode >= 200 &&
      statusCode < 300;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'] ?? 0,
      errorCode: json['errorCode'] as int?,
      data: json['data'] != null
          ? (fromJsonT != null
              ? fromJsonT(json['data'] as Map<String, dynamic>)
              : json['data'] as T)
          : null,
      traceId: json['traceId'] as String?,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T)? toJsonT) => {
        'statusCode': statusCode,
        'errorCode': errorCode,
        'data': data != null && toJsonT != null ? toJsonT(data as T) : null,
        'traceId': traceId,
      };
}
