import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/error/simple_light_error_pressed_icon.dart';

class SErrorPressedIcon extends ConsumerWidget {
  const SErrorPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightErrorPressedIcon();
    } else {
      return const SimpleLightErrorPressedIcon();
    }
  }
}
