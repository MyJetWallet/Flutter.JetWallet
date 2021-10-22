import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/keyboard_erase/simple_light_keyboard_erase_pressed_icon.dart';

class SKeyboardErasePressedIcon extends ConsumerWidget {
  const SKeyboardErasePressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightKeyboardErasePressedIcon();
    } else {
      return const SimpleLightKeyboardErasePressedIcon();
    }
  }
}
