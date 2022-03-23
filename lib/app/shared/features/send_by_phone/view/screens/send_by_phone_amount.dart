import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../models/currency_model.dart';
import 'components/send_by_phone_amount_medium.dart';
import 'components/send_by_phone_amount_small.dart';

class SendByPhoneAmount extends HookWidget {
  const SendByPhoneAmount({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);

    return deviceSize.when(
      small: () => SendByPhoneAmountSmall(currency: currency),
      medium: () => SendByPhoneAmountMedium(currency: currency),
    );
  }
}
