import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/pause/simple_light_pause_icon.dart';

class SPauseIcon extends ConsumerWidget {
  const SPauseIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPauseIcon();
    } else {
      return const SimpleLightPauseIcon();
    }
  }
}
