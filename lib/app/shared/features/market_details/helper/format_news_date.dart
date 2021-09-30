import 'package:timeago/timeago.dart' as timeago;

String formatNewsDate(String timestamp) => ' ${timeago.format(
  DateTime.parse('${timestamp}Z').toLocal(),
)}';
