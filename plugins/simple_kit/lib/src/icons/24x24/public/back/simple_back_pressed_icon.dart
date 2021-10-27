import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/back/simple_light_back_pressed_icon.dart';

class SBackPressedIcon extends ConsumerWidget {
  const SBackPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightBackPressedIcon();
    } else {
      return const SimpleLightBackPressedIcon();
    }
  }
}
