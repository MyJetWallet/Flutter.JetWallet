import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/earn/simple_light_earn_active_icon.dart';

class SEarnActiveIcon extends ConsumerWidget {
  const SEarnActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightEarnActiveIcon();
    } else {
      return const SimpleLightEarnActiveIcon();
    }
  }
}
