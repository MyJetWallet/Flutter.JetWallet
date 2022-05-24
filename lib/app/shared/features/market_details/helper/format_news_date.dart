import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../shared/providers/service_providers.dart';

String formatNewsDate(String timestamp) => ' ${timeago.format(
      DateTime.parse('${timestamp}Z').toLocal(),
    )}';

String formatBannersDate(
  String time,
  BuildContext context,
) {
  final intl = context.read(intlPod);

  final dateTime = DateTime.parse(time);
  final days = dateTime.day;
  final hours = dateTime.hour;
  return '$days ${intl.days} $hours ${intl.hoursLeft}';
}
