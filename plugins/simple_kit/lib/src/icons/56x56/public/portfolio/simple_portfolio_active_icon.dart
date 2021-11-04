import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/portfolio/simple_light_portfolio_active_icon.dart';

class SPortfolioActiveIcon extends ConsumerWidget {
  const SPortfolioActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPortfolioActiveIcon();
    } else {
      return const SimpleLightPortfolioActiveIcon();
    }
  }
}
