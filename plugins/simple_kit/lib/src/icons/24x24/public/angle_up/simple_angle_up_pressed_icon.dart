import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/angle_up/simple_light_angle_up_pressed_icon.dart';

class SAngleUpPressedIcon extends ConsumerWidget {
  const SAngleUpPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightAngleUpPressedIcon();
    } else {
      return const SimpleLightAngleUpPressedIcon();
    }
  }
}
