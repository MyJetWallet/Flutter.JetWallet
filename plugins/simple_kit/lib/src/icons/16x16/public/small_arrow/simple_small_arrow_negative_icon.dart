import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/small_arrow/simple_light_small_arrow_negative_icon.dart';

class SSmallArrowNegativeIcon extends ConsumerWidget {
  const SSmallArrowNegativeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSmallArrowNegativeIcon();
    } else {
      return const SimpleLightSmallArrowNegativeIcon();
    }
  }
}
