import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/numeric_keyboard_face_id/simple_light_numeric_keyboard_face_id_pressed_icon.dart';

class SNumericKeyboardFaceIdPressedIcon extends ConsumerWidget {
  const SNumericKeyboardFaceIdPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNumericKeyboardFaceIdPressedIcon();
    } else {
      return const SimpleLightNumericKeyboardFaceIdPressedIcon();
    }
  }
}
