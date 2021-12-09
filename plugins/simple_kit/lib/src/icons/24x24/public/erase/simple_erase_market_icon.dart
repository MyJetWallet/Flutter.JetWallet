import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/erase/simple_light_erase_market.dart';

class SEraseMarketIcon extends ConsumerWidget {
  const SEraseMarketIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightEraseMarketIcon();
    } else {
      return const SimpleLightEraseMarketIcon();
    }
  }
}
