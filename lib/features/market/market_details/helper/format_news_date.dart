import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatNewsDate(String timestamp) => ' ${timeago.format(
      DateTime.parse('${timestamp}Z').toLocal(),
    )}';

String formatBannersDate(
  String time,
  BuildContext context,
) {
  final dateTime = DateTime.parse(time);
  final days = dateTime.day;
  final hours = dateTime.hour;

  return '$days ${intl.days} $hours ${intl.hoursLeft}';
}
