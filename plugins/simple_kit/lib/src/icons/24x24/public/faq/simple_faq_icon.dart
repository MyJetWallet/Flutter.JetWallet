import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/faq/simple_light_faq_icon.dart';

class SFaqIcon extends ConsumerWidget {
  const SFaqIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightFaqIcon();
    } else {
      return const SimpleLightFaqIcon();
    }
  }
}
