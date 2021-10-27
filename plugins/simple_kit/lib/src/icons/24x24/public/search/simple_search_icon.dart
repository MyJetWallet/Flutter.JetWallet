import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/search/simple_light_search_icon.dart';

class SSearchIcon extends ConsumerWidget {
  const SSearchIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSearchIcon();
    } else {
      return const SimpleLightSearchIcon();
    }
  }
}
