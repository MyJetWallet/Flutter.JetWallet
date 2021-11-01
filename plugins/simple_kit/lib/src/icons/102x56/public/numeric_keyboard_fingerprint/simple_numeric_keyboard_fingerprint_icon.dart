import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/numeric_keyboard_fingerprint/simple_light_numeric_keyboard_fingerprint_icon.dart';

class SNumericKeyboardFingerprintIcon extends ConsumerWidget {
  const SNumericKeyboardFingerprintIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNumericKeyboardFingerprintIcon();
    } else {
      return const SimpleLightNumericKeyboardFingerprintIcon();
    }
  }
}
