import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/plus/simple_light_plus_icon.dart';

class SPlusIcon extends ConsumerWidget {
  const SPlusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPlusIcon();
    } else {
      return const SimpleLightPlusIcon();
    }
  }
}
