import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/persona/simple_light_selfie.dart';

class SSelfieIcon extends ConsumerWidget {
  const SSelfieIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightSelfieIcon(
        color: color,
      );
    } else {
      return SimpleLightSelfieIcon(
        color: color,
      );
    }
  }
}
