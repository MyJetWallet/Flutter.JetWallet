import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action/simple_light_action_active_highlighted_icon.dart';

class SActionActiveHighlightedIcon extends ConsumerWidget {
  const SActionActiveHighlightedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionActiveHighlightedIcon();
    } else {
      return const SimpleLightActionActiveHighlightedIcon();
    }
  }
}
