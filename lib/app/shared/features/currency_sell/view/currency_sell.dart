import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../models/currency_model.dart';
import 'components/currency_sell_small.dart';
import 'components/currency_small_medium.dart';

class CurrencySell extends HookWidget {
  const CurrencySell({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);

    return deviceSize.when(
      small: () => CurrencySellSmall(currency: currency),
      medium: () => CurrencySellMedium(currency: currency),
    );
  }
}
