import 'package:intl/intl.dart';

const uiDateFormat = 'd MMM yyyy';
const backEndDateFormat = 'yyyy.MM.dd';

DateTime getMinBirtDate() {
  final today = DateTime.now();
  return DateTime(today.year - 18, today.month, today.day);
}

String formatDateForUi(DateTime date) {
  final dateFormatter = DateFormat(uiDateFormat);
  return dateFormatter.format(date);
}

String formatDateForBackEnd(String date) {
  final tempDate = DateFormat(uiDateFormat).parse(date);
  final dateFormatter = DateFormat(backEndDateFormat);
  return dateFormatter.format(tempDate);
}
