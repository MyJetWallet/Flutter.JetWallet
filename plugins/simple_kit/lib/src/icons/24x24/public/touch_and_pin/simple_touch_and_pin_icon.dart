import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/touch_and_pin/simple_light_touch_and_pin_icon.dart';

class STouchAndPinIcon extends ConsumerWidget {
  const STouchAndPinIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightTouchAndPinIcon();
    } else {
      return const SimpleLightTouchAndPinIcon();
    }
  }
}
