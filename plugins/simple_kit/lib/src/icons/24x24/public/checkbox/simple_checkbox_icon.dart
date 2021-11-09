import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/checkbox/simple_light_checkbox_icon.dart';

class SCheckboxIcon extends ConsumerWidget {
  const SCheckboxIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCheckboxIcon();
    } else {
      return const SimpleLightCheckboxIcon();
    }
  }
}
