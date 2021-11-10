import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/log_out/simple_log_out_icon.dart';

class SLogOutIcon extends ConsumerWidget {
  const SLogOutIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightLogOutIcon();
    } else {
      return const SimpleLightLogOutIcon();
    }
  }
}
