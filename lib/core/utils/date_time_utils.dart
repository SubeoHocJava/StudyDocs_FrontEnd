
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatTimeAgo(DateTime dateTime) {
    final utcTime = dateTime.isUtc 
        ? dateTime 
        : DateTime.utc(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond, dateTime.microsecond);
    final now = DateTime.now().toUtc();
    final difference = now.difference(utcTime);

    if (difference.isNegative) {
      return 'Vừa xong';
    }

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
