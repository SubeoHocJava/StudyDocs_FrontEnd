class PaginatedResult<T> {
  final List<T> data;
  final dynamic nextCursor;
  final int total;
  final bool hasNext;

  PaginatedResult({
    required this.data,
    this.nextCursor,
    required this.total,
    required this.hasNext,
  });
}
