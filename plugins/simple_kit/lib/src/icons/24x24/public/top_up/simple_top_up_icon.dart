import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/top_up/simple_light_top_up_icon.dart';

class STopUpIcon extends ConsumerWidget {
  const STopUpIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightTopUpIcon();
    } else {
      return const SimpleLightTopUpIcon();
    }
  }
}
