import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/tick/simple_light_stats_icon.dart';

class SStatsIcon extends ConsumerWidget {
  const SStatsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightStatsIcon();
    } else {
      return const SimpleLightStatsIcon();
    }
  }
}
