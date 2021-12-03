import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/adv_cash/simple_light_adv_cash_icon.dart';

class SAdvCashIcon extends ConsumerWidget {
  const SAdvCashIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightAdvCashIcon();
    } else {
      return const SimpleLightAdvCashIcon();
    }
  }
}
