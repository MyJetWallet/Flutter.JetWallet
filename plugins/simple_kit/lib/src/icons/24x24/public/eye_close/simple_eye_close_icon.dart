import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/eye_close/simple_light_eye_close_icon.dart';

class SEyeCloseIcon extends ConsumerWidget {
  const SEyeCloseIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightEyeCloseIcon();
    } else {
      return const SimpleLightEyeCloseIcon();
    }
  }
}
