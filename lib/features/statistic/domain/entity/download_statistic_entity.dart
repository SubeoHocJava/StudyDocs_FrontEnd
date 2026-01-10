/// Entity representing download statistics for a specific date
class DownloadStatisticEntity {
  final DateTime date;
  final int count;

  const DownloadStatisticEntity({
    required this.date,
    required this.count,
  });

  @override
  String toString() => 'DownloadStatisticEntity(date: $date, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadStatisticEntity &&
        other.date == date &&
        other.count == count;
  }

  @override
  int get hashCode => date.hashCode ^ count.hashCode;
}
