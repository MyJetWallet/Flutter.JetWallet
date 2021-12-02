import 'package:timeago/timeago.dart' as timeago;

String formatNewsDate(String timestamp) => ' ${timeago.format(
  DateTime.parse('${timestamp}Z').toLocal(),
)}';

String formatBannersDate(String timestamp) {
  if (timestamp.contains('.')) {
    final getDays = timestamp.split('.');
    final getHours = getDays[1].split(':')[0];
    return '${getDays[0]} days $getHours hours left';
  } else {
    var getHours = timestamp.split(':')[0];
    if (getHours == '00') {
      getHours = '0';
    }
    return '0 days $getHours hours left';
  }
}
