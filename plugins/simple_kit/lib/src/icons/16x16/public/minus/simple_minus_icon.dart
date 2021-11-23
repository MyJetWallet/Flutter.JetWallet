import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../minus/simple_light_minus.dart';

class SMinusIcon extends ConsumerWidget {
  const SMinusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightMinusIcon();
    } else {
      return const SimpleLightMinusIcon();
    }
  }
}
