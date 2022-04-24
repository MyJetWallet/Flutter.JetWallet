import 'package:intl/intl.dart';

String formatDateToHm(String? timeStamp) => timeStamp == null
    ? ''
    : DateFormat('Hm').format(DateTime.parse('${timeStamp}Z').toLocal());

String formatDateToDMY(String? timeStamp) => timeStamp == null
    ? ''
    : DateFormat('dd.MM.yyyy')
        .format(DateTime.parse('${timeStamp}Z').toLocal());

String convertDateToTomorrowOrDate(String? timeStamp) {
  if (timeStamp == null) {
    return '';
  } else {
    final now = DateTime.now();
    final date = DateTime.parse('${timeStamp}Z').toLocal();
    final isTomorrow = DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        1;

    return isTomorrow ? 'Tomorrow' : DateFormat('dd.MM.yyyy').format(date);
  }
}
