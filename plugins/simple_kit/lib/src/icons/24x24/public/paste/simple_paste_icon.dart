import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/paste/simple_light_paste_icon.dart';

class SPasteIcon extends ConsumerWidget {
  const SPasteIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPasteIcon();
    } else {
      return const SimpleLightPasteIcon();
    }
  }
}
