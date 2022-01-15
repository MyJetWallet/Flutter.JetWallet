import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/paid_interest_rate/simple_light_paid_interest_rate_icon.dart';

class SPaidInterestRateIcon extends ConsumerWidget {
  const SPaidInterestRateIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPaidInterestRateIcon();
    } else {
      return const SimpleLightPaidInterestRateIcon();
    }
  }
}
