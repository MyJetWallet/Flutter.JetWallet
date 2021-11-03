import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/news/simple_light_news_default_icon.dart';

class SNewsDefaultIcon extends ConsumerWidget {
  const SNewsDefaultIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNewsDefaultIcon();
    } else {
      return const SimpleLightNewsDefaultIcon();
    }
  }
}
