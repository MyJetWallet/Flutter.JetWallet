import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/complete/simple_light_complete_icon.dart';

class SCompleteIcon extends ConsumerWidget {
  const SCompleteIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightCompleteIcon(
        color: color,
      );
    } else {
      return SimpleLightCompleteIcon(
        color: color,
      );
    }
  }
}
