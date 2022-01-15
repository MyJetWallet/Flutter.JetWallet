import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/swap/simple_light_swap_icon.dart';

class SSwapIcon extends ConsumerWidget {
  const SSwapIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSwapIcon();
    } else {
      return const SimpleLightSwapIcon();
    }
  }
}
