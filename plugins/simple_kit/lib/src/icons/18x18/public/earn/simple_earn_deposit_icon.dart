import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/earn/simple_light_earn_deposit_icon.dart';

class SEarnDepositIcon extends ConsumerWidget {
  const SEarnDepositIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightEarnDepositIcon(
        color: color,
      );
    } else {
      return SimpleLightEarnDepositIcon(
        color: color,
      );
    }
  }
}
