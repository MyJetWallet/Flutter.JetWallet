import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/index_history/simple_light_index_history_icon.dart';

class SIndexHistoryIcon extends ConsumerWidget {
  const SIndexHistoryIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightIndexHistoryIcon();
    } else {
      return const SimpleLightIndexHistoryIcon();
    }
  }
}
