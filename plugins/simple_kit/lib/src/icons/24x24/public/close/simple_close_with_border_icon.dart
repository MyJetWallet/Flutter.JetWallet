import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/close/simple_light_close_with_border_icon.dart';

class SCloseWithBorderIcon extends ConsumerWidget {
  const SCloseWithBorderIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCloseWithBorderIcon();
    } else {
      return const SimpleLightCloseWithBorderIcon();
    }
  }
}
