import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/checkbox/simple_light_checkbox_selected_icon.dart';

class SCheckboxSelectedIcon extends ConsumerWidget {
  const SCheckboxSelectedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCheckboxSelectedIcon();
    } else {
      return const SimpleLightCheckboxSelectedIcon();
    }
  }
}
