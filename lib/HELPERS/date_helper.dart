import 'package:intl/intl.dart';

class DataFormateHelper {
  static String formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('MMMM dd, yyyy').format(date);
    } else {
      return 'Unknown';
    }
  }

  static String formateDateWithHrs(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } else {
      return 'N/A';
    }
  }
}
