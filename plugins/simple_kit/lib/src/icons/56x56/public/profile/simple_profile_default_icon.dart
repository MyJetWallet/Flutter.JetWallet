import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/profile/simple_light_profile_default_icon.dart';

class SProfileDefailtIcon extends ConsumerWidget {
  const SProfileDefailtIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightProfileDefaultIcon();
    } else {
      return const SimpleLightProfileDefaultIcon();
    }
  }
}
