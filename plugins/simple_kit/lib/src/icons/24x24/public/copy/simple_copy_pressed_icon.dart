import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/copy/simple_light_copy_pressed_icon.dart';

class SCopyPressedIcon extends ConsumerWidget {
  const SCopyPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCopyPressedIcon();
    } else {
      return const SimpleLightCopyPressedIcon();
    }
  }
}
