import 'package:intl/intl.dart';

const uiDateFormat = 'd MMM yyyy';
const backEndDateFormat = 'yyyy.MM.dd';

DateTime getMinBirthDate() {
  final today = DateTime.now();
  return DateTime(today.year - 18, today.month, today.day);
}
DateTime getDateForPicker() {
  final today = DateTime.now();
  return DateTime(today.year - 17, today.month, today.day);
}

bool isBirthDateValid(String selectedDate) {
  final userDate = DateFormat(uiDateFormat).parse(selectedDate);
  final today = DateTime.now();
  final minDate = DateTime(today.year - 18, today.month, today.day);
  return userDate.isAfter(minDate);
}

String formatDateForUi(DateTime date) {
  final dateFormatter = DateFormat(uiDateFormat);
  return dateFormatter.format(date);
}

String formatDateForBackEnd(String date) {
  final userDate = DateFormat(uiDateFormat).parse(date);
  final dateFormatter = DateFormat(backEndDateFormat);
  return dateFormatter.format(userDate);
}
