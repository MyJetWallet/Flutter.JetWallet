import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_receive/simple_light_action_receive_icon.dart';

class SActionReceiveIcon extends ConsumerWidget {
  const SActionReceiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionReceiveIcon();
    } else {
      return const SimpleLightActionReceiveIcon();
    }
  }
}
