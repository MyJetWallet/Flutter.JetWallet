import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/tick/simple_light_tick_icon.dart';

class STickIcon extends ConsumerWidget {
  const STickIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightTickIcon();
    } else {
      return const SimpleLightTickIcon();
    }
  }
}
