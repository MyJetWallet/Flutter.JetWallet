import 'package:intl/intl.dart';

String formatDateToHm(String timeStamp) =>
    DateFormat('Hm').format(DateTime.parse('${timeStamp}Z').toLocal());

String formatDateToDMY(String timeStamp) =>
    DateFormat('dd.MM.yyyy').format(DateTime.parse('${timeStamp}Z').toLocal());
