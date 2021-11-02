import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/numeric_keyboard_fingerprint/simple_light_numeric_keyboard_fingerprint_pressed_icon.dart';

class SNumericKeyboardFingerprintPressedIcon extends ConsumerWidget {
  const SNumericKeyboardFingerprintPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNumericKeyboardFingerprintPressedIcon();
    } else {
      return const SimpleLightNumericKeyboardFingerprintPressedIcon();
    }
  }
}
