import 'package:intl/intl.dart';

String formatDate(String timeStamp) => DateFormat.MMMM().format(DateTime.parse('${timeStamp}Z').toLocal());
