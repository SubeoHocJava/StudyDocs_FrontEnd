class TimeUtils {
  static String formatTimeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} năm';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} tháng';
    } else if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()} tuần';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} ngày';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} giờ';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} phút';
    } else {
      return 'Vừa xong';
    }
  }
}
