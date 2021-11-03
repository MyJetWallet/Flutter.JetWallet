import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_convert/simple_light_action_convert_icon.dart';

class SActionConvertIcon extends ConsumerWidget {
  const SActionConvertIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionConvertIcon();
    } else {
      return const SimpleLightActionConvertIcon();
    }
  }
}
