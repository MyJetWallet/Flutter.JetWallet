import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/circle_minus/simple_light_circle_minus.dart';

class SCircleMinusIcon extends ConsumerWidget {
  const SCircleMinusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCircleMinusIcon();
    } else {
      return const SimpleLightCircleMinusIcon();
    }
  }
}
