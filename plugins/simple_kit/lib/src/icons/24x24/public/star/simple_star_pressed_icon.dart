import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/star/simple_light_star_pressed_icon.dart';

class SStarPressedIcon extends ConsumerWidget {
  const SStarPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightStarPressedIcon();
    } else {
      return const SimpleLightStarPressedIcon();
    }
  }
}
