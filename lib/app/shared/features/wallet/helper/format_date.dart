import 'package:intl/intl.dart';

String formatDate(String timeStamp) => DateFormat('EEEE, MMMM d, y')
    .format(DateTime.parse('${timeStamp}Z').toLocal());
