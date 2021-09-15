import 'package:intl/intl.dart';

String formatDateToHm(String timeStamp) =>
    DateFormat('Hm').format(DateTime.parse('${timeStamp}Z').toLocal());
