import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_deposit/simple_light_action_deposit_icon.dart';

class SActionDepositIcon extends ConsumerWidget {
  const SActionDepositIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionDepositIcon();
    } else {
      return const SimpleLightActionDepositIcon();
    }
  }
}
