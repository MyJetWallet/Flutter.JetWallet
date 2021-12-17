import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/lock/simple_light_lock_icon.dart';

class SLockIcon extends ConsumerWidget {
  const SLockIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightLockIcon();
    } else {
      return const SimpleLightLockIcon();
    }
  }
}
