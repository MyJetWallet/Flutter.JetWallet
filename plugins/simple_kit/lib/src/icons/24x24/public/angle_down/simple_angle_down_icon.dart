import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/angle_down/simple_light_angle_down_icon.dart';

class SAngleDownIcon extends ConsumerWidget {
  const SAngleDownIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightAngleDownIcon(
        color: color,
      );
    } else {
      return SimpleLightAngleDownIcon(
        color: color,
      );
    }
  }
}
