import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/paused/simple_light_paused_icon.dart';

class SPausedIcon extends ConsumerWidget {
  const SPausedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPausedIcon();
    } else {
      return const SimpleLightPausedIcon();
    }
  }
}
