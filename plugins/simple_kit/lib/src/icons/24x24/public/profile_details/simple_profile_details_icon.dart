import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/profile_details/simple_profile_details_icon.dart';

class SProfileDetailsIcon extends ConsumerWidget {
  const SProfileDetailsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightProfileDetailsIcon();
    } else {
      return const SimpleLightProfileDetailsIcon();
    }
  }
}
