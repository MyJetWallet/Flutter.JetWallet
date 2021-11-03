import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_sell/simple_light_action_sell_icon.dart';

class SActionSellIcon extends ConsumerWidget {
  const SActionSellIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionSellIcon();
    } else {
      return const SimpleLightActionSellIcon();
    }
  }
}
