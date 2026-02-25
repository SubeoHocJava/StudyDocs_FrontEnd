
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} tháng';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút';
    } else {
      return 'Vừa xong';
    }
  }
}
