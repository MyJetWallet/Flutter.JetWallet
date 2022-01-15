import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/withdrawal_fee/simple_light_withdrawal_fee_icon.dart';

class SWithdrawalFeeIcon extends ConsumerWidget {
  const SWithdrawalFeeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightWithdrawalFeeIcon();
    } else {
      return const SimpleLightWithdrawalFeeIcon();
    }
  }
}
