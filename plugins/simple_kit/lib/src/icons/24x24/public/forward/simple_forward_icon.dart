import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/forward/simple_light_forward_icon.dart';

class SForwardIcon extends ConsumerWidget {
  const SForwardIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightForwardIcon();
    } else {
      return const SimpleLightForwardIcon();
    }
  }
}
