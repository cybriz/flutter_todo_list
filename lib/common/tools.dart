import 'package:intl/intl.dart';

class Tools {
  static String formattedDate(DateTime date) {
    return '${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)} ${DateFormat.y().format(date)}';
  }

  static String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;

    return '${hour.toString().padLeft(2, "0")} hrs ${minutes.toString().padLeft(2, "0")} min';
  }

  static String getDateAndTime(DateTime value) {
    return '${DateFormat.d().format(value)} ${DateFormat.MMM().format(value)} ${DateFormat.y().format(value)}, ${DateFormat.Hm().format(value)}';
  }
}
