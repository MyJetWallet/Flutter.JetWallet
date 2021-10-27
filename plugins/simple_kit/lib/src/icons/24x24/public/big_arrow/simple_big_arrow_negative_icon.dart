import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/big_arrow/simple_light_big_arrow_negative.dart';

class SBigArrowNegativeIcon extends ConsumerWidget {
  const SBigArrowNegativeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightBigArrowNegativeIcon();
    } else {
      return const SimpleLightBigArrowNegativeIcon();
    }
  }
}
