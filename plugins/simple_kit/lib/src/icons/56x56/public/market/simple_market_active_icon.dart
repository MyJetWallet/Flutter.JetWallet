import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/market/simple_light_market_active_icon.dart';

class SMarketActiveIcon extends ConsumerWidget {
  const SMarketActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightMarketActiveIcon();
    } else {
      return const SimpleLightMarketActiveIcon();
    }
  }
}
