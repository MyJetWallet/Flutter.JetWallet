import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_buy/simple_light_action_buy_icon.dart';

class SActionBuyIcon extends ConsumerWidget {
  const SActionBuyIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionBuyIcon();
    } else {
      return const SimpleLightActionBuyIcon();
    }
  }
}
