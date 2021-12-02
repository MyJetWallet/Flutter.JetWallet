import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/paste/simple_light_paste_pressed_icon.dart';

class SPastePressedIcon extends ConsumerWidget {
  const SPastePressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPastePressedIcon();
    } else {
      return const SimpleLightPastePressedIcon();
    }
  }
}
