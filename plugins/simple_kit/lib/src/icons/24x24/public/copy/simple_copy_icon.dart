import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/copy/simple_light_copy_icon.dart';

class SCopyIcon extends ConsumerWidget {
  const SCopyIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightCopyIcon();
    } else {
      return const SimpleLightCopyIcon();
    }
  }
}
