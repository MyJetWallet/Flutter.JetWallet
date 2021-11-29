import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/gift_portfolio/simple_light_portfolio_gift_icon.dart';

class SGiftPortfolioIcon extends ConsumerWidget {
  const SGiftPortfolioIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightGiftPortfolioIcon();
    } else {
      return const SimpleLightGiftPortfolioIcon();
    }
  }
}
