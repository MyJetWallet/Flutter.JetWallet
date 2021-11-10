import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/support/simple_support_icon.dart';

class SSupportIcon extends ConsumerWidget {
  const SSupportIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSupportIcon();
    } else {
      return const SimpleLightSupportIcon();
    }
  }
}
