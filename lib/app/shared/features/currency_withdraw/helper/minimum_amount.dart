import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../models/currency_model.dart';

/// Used when [InputError.enterHigherAmount]
String minimumAmount(CurrencyModel currency, BuildContext context) {
  final intl = context.read(intlPod);

  if (currency.isFeeInOtherCurrency) {
    return intl.minimumAmount_noMinimum;
  } else {
    return '${intl.min1} ${currency.withdrawalFeeSize} ${currency.symbol}';
  }
}
