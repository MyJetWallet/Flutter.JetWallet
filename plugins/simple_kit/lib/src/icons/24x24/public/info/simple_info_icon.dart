import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/info/simple_light_info_icon.dart';

class SInfoIcon extends ConsumerWidget {
  const SInfoIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightInfoIcon(
        color: color,
      );
    } else {
      return SimpleLightInfoIcon(
        color: color,
      );
    }
  }
}
