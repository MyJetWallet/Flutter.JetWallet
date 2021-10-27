import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/tick/simple_light_tick_selected_icon.dart';

class STickSelectedIcon extends ConsumerWidget {
  const STickSelectedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightTickSelectedIcon();
    } else {
      return const SimpleLightTickSelectedIcon();
    }
  }
}
