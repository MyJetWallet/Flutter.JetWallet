import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';

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

  return change > 0 ? colors.green : colors.red;
}
