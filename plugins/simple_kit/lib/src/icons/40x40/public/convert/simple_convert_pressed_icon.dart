import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/convert/simple_light_convert_pressed_icon.dart';

class SConvertPressedIcon extends ConsumerWidget {
  const SConvertPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightConvertPressedIcon();
    } else {
      return const SimpleLightConvertPressedIcon();
    }
  }
}
