import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/reward_payment/simple_light_reward_payment_icon.dart';

class SRewardPaymentIcon extends ConsumerWidget {
  const SRewardPaymentIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightRewardPaymentIcon();
    } else {
      return const SimpleLightRewardPaymentIcon();
    }
  }
}
