import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/angle_down/simple_light_angle_down_icon.dart';

class SAngleDownIcon extends ConsumerWidget {
  const SAngleDownIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightAngleDownIcon();
    } else {
      return const SimpleLightAngleDownIcon();
    }
  }
}
