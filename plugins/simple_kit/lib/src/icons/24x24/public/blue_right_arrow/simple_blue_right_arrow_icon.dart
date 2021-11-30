import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/blue_right_arrow/simple_light_blue_right_arrow_icon.dart';

class SBlueRightArrowIcon extends ConsumerWidget {
  const SBlueRightArrowIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightBlueRightArrowIcon();
    } else {
      return const SimpleLightBlueRightArrowIcon();
    }
  }
}
