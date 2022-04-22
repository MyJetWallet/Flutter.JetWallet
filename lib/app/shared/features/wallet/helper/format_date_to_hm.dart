import 'package:intl/intl.dart';

String formatDateToHm(String? timeStamp) {
  if (timeStamp == null) {
    return '';
  } else {
    return DateFormat('Hm').format(DateTime.parse('${timeStamp}Z').toLocal());
  }
}

String formatDateToDMY(String? timeStamp) {
  if (timeStamp == null) {
    return '';
  } else {
    return DateFormat('dd.MM.yyyy')
        .format(DateTime.parse('${timeStamp}Z').toLocal());
  }
}
