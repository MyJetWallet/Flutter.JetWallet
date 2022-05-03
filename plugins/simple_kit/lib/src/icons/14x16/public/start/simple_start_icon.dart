import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/start/simple_light_start_icon.dart';

class SStartIcon extends ConsumerWidget {
  const SStartIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightStartIcon();
    } else {
      return const SimpleLightStartIcon();
    }
  }
}
