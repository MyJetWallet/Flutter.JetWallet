import 'package:intl/intl.dart';

String formatDateToHm(String timeStamp) =>
    DateFormat('Hm').format(DateTime.parse('${timeStamp}Z').toLocal());

String formatDateToDMY(String timeStamp) =>
    DateFormat('dd.MM.yyyy').format(DateTime.parse('${timeStamp}Z').toLocal());

String formatDateToHmFromDate(String time) =>
    DateFormat('Hm').format(DateTime.parse(time).toLocal());

String formatDateToDMYFromDate(String time) =>
    DateFormat('dd.MM.yyyy').format(DateTime.parse(time).toLocal());
