class CursorPaginationResult<T> {
  final List<T> data;
  final dynamic nextCursor;
  final int total;
  final bool hasNext;

  CursorPaginationResult({
    required this.data,
    this.nextCursor,
    required this.total,
    required this.hasNext,
  });

  factory CursorPaginationResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return CursorPaginationResult<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      nextCursor: json['nextCursor'],
      total: json['total'] is int ? json['total'] : int.parse(json['total']?.toString() ?? '0'),
      hasNext: json['hasNext'] ?? false,
    );
  }
}
