import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/about_us/simple_light_about_us_icon.dart';

class SAboutUsIcon extends ConsumerWidget {
  const SAboutUsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightAboutUsIcon();
    } else {
      return const SimpleLightAboutUsIcon();
    }
  }
}