import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../model/withdrawal_model.dart';
import 'components/withdrawal_amount_medium.dart';
import 'components/withdrawal_amount_small.dart';

class WithdrawalAmount extends HookWidget {
  const WithdrawalAmount({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);

    return deviceSize.when(
      small: () => WithdrawalAmountSmall(withdrawal: withdrawal),
      medium: () => WithdrawalAmountMedium(withdrawal: withdrawal),
    );
  }
}
