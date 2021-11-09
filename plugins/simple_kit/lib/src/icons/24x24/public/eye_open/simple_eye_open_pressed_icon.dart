import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/eye_open/simple_light_eye_open_pressed_icon.dart';

class SEyeOpenPressedIcon extends ConsumerWidget {
  const SEyeOpenPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightEyeOpenPressedIcon();
    } else {
      return const SimpleLightEyeOpenPressedIcon();
    }
  }
}
