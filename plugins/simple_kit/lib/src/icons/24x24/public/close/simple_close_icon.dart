import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/close/simple_light_close_icon.dart';

class SCloseIcon extends ConsumerWidget {
  const SCloseIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightCloseIcon(color: color,);
    } else {
      return SimpleLightCloseIcon(color: color,);
    }
  }
}
