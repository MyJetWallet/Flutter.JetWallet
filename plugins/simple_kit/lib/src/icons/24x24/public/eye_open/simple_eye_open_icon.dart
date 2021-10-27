import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/eye_open/simple_light_eye_open_icon.dart';

class SEyeOpenIcon extends ConsumerWidget {
  const SEyeOpenIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightEyeOpenIcon();
    } else {
      return const SimpleLightEyeOpenIcon();
    }
  }
}
