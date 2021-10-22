import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_withdraw/simple_light_action_withdraw_icon.dart';

class SActionWithdrawIcon extends ConsumerWidget {
  const SActionWithdrawIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionWithdrawIcon();
    } else {
      return const SimpleLightActionWithdrawIcon();
    }
  }
}
