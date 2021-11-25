import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_deposit/simple_light_action_deposit_icon.dart';

class SActionDepositIcon extends ConsumerWidget {
  const SActionDepositIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightActionDepositIcon(
        color: color,
      );
    } else {
      return SimpleLightActionDepositIcon(
        color: color,
      );
    }
  }
}
