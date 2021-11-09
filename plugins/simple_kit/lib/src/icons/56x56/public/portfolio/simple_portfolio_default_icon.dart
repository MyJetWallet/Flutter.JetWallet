import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/portfolio/simple_light_portfolio_default_icon.dart';

class SPortfolioDefaultIcon extends ConsumerWidget {
  const SPortfolioDefaultIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPortfolioDefaultIcon();
    } else {
      return const SimpleLightPortfolioDefaultIcon();
    }
  }
}
