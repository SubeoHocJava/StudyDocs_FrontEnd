class ApiResponse<T> {
  final int statusCode;
  final int errorCode;
  final String traceId;
  final T data;

  ApiResponse(this.statusCode, this.errorCode, this.traceId, this.data);

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      json['statusCode'] as int,
      json['errorCode'] as int,
      json['traceId'] as String,
      json['repository'] as T,
    );
  }
}
