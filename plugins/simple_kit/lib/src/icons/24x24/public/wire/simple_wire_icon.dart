import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/wire/simple_light_wire_icon.dart';

class SWireIcon extends ConsumerWidget {
  const SWireIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightWireIcon();
    } else {
      return const SimpleLightWireIcon();
    }
  }
}
