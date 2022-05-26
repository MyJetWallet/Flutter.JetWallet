import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/earn/simple_light_earn_default_icon.dart';

class SEarnDefaultIcon extends ConsumerWidget {
  const SEarnDefaultIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightEarnDefaultIcon();
    } else {
      return const SimpleLightEarnDefaultIcon();
    }
  }
}
