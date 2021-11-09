import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action/simple_light_action_active_icon.dart';

class SActionActiveIcon extends ConsumerWidget {
  const SActionActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionActiveIcon();
    } else {
      return const SimpleLightActionActiveIcon();
    }
  }
}
