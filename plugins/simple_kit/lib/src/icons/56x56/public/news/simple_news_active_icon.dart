import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/news/simple_light_news_active_icon.dart';

class SNewsActiveIcon extends ConsumerWidget {
  const SNewsActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNewsActiveIcon();
    } else {
      return const SimpleLightNewsActiveIcon();
    }
  }
}
