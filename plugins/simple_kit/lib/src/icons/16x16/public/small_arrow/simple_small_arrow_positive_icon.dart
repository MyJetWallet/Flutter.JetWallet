import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/small_arrow/simple_light_small_arrow_positive.dart';

class SSmallArrowPositiveIcon extends ConsumerWidget {
  const SSmallArrowPositiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSmallArrowPositiveIcon();
    } else {
      return const SimpleLightSmallArrowPositiveIcon();
    }
  }
}
