import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/gift/simple_light_gift_pressed_icon.dart';

class SGiftPressedIcon extends ConsumerWidget {
  const SGiftPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightGiftPressedIcon();
    } else {
      return const SimpleLightGiftPressedIcon();
    }
  }
}
