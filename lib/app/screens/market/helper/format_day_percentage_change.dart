import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/constants.dart';

// TODO(any): move to shared helper or remove
String formatDayPercentageChange(double change) {
  final formattedChange = change.toStringAsFixed(signsAfterComma);

  if (change == 0) {
    return '0%';
  } else if (change > 0) {
    return '+$formattedChange%';
  } else {
    return '$formattedChange%';
  }
}

Color colorDayPercentage(double change, SimpleColors colors) {
  if (change == 0) return colors.grey1;

  if (change > 0) {
    return colors.green;
  } else {
    return colors.red;
  }
}
