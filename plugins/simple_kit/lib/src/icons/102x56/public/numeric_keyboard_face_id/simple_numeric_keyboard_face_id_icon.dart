import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/numeric_keyboard_face_id/simple_light_numeric_keyboard_face_id_icon.dart';

class SNumericKeyboardFaceIdIcon extends ConsumerWidget {
  const SNumericKeyboardFaceIdIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNumericKeyboardFaceIdIcon();
    } else {
      return const SimpleLightNumericKeyboardFaceIdIcon();
    }
  }
}
