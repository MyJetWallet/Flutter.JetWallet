import 'package:timeago/timeago.dart' as timeago;

String formatNewsDate(String timestamp) => ' ${timeago.format(
  DateTime.parse('${timestamp}Z').toLocal(),
)}';


String formatBannersDate(String time) {
  final dateTime = DateTime.parse(time);
  final days = dateTime.day;
  final hours = dateTime.hour;
  return '$days days $hours hours left';
}
