import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/cross/simple_light_cross_icon.dart';

class SCrossIcon extends ConsumerWidget {
  const SCrossIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCrossIcon();
    } else {
      return const SimpleLightCrossIcon();
    }
  }
}
