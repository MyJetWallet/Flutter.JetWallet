import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers/service_providers.dart';

String localizedMonth(
    String month,
    BuildContext context,
    ) {
  final intl = context.read(intlPod);

  switch (month) {
    case 'January':
      return intl.january;
    case 'Febuary':
      return intl.febuary;
    case 'March':
      return intl.march;
    case 'April':
      return intl.april;
    case 'May':
      return intl.may;
    case 'June':
      return intl.june;
    case 'July':
      return intl.july;
    case 'August':
      return intl.august;
    case 'September':
      return intl.september;
    case 'October':
      return intl.october;
    case 'November':
      return intl.november;
    case 'December':
      return intl.december;
    default:
      return '';
  }
}
