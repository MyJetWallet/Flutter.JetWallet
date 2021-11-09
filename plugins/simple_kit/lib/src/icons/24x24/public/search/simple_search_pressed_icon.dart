import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/search/simple_light_search_pressed_icon.dart';

class SSearchPressedIcon extends ConsumerWidget {
  const SSearchPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSearchPressedIcon();
    } else {
      return const SimpleLightSearchPressedIcon();
    }
  }
}
