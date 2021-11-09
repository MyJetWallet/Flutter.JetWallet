import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/erase/simple_light_erase_pressed_icon.dart';

class SErasePressedIcon extends ConsumerWidget {
  const SErasePressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightErasePressedIcon();
    } else {
      return const SimpleLightErasePressedIcon();
    }
  }
}
