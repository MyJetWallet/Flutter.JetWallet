import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/numeric_keyboard_erase/simple_light_numeric_keyboard_erase_icon.dart';

class SNumericKeyboardEraseIcon extends ConsumerWidget {
  const SNumericKeyboardEraseIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNumericKeyboardEraseIcon();
    } else {
      return const SimpleLightNumericKeyboardEraseIcon();
    }
  }
}
