import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/complete/simple_light_complete_solid_icon.dart';

class SCompleteSolidIcon extends ConsumerWidget {
  const SCompleteSolidIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCompleteSolidIcon();
    } else {
      return const SimpleLightCompleteSolidIcon();
    }
  }
}
