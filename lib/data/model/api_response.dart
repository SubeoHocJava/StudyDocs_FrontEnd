class ApiResponse<T> {
  final int statusCode;
  final int? errorCode;
  final String traceId;
  final T data;

  ApiResponse({
    required this.statusCode,
    required this.errorCode,
    required this.traceId,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'],
      errorCode: json['errorCode'] != null ? json['errorCode'] as int : null,
      traceId: json['traceId'] ?? '',
      data: json['data'],
    );
  }
}
