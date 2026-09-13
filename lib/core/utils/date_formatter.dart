import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _dateFormat = DateFormat('d MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('d MMM yyyy, h:mm a');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _shortDateFormat = DateFormat('d MMM');

  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(itemDate).inDays;

    if (difference == 0) {
      return 'Today, ${formatTime(date)}';
    } else if (difference == 1) {
      return 'Yesterday, ${formatTime(date)}';
    } else if (difference < 7 && difference > 0) {
      return '${DateFormat('EEEE').format(date)}, ${formatTime(date)}';
    } else {
      return formatDateTime(date);
    }
  }

  static String formatExpenseDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(itemDate).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return formatDate(date);
    }
  }
}
