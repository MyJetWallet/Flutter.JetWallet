import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/change_pin/simple_light_change_pin_icon.dart';

class SChangePinIcon extends ConsumerWidget {
  const SChangePinIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightChangePinIcon();
    } else {
      return const SimpleLightChangePinIcon();
    }
  }
}
