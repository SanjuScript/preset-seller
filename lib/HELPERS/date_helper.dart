import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('MMMM dd, yyyy').format(date);
    } else {
      return 'Unknown';
    }
  }