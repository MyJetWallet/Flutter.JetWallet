import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/info/simple_light_info_pressed_icon.dart';

class SInfoPressedIcon extends ConsumerWidget {
  const SInfoPressedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightInfoPressedIcon(
        color: color,
      );
    } else {
      return SimpleLightInfoPressedIcon(
        color: color,
      );
    }
  }
}
