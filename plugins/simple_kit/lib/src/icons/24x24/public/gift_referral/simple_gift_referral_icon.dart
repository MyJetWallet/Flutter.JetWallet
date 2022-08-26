import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/gift_referral/simple_light_portfolio_gift_icon.dart';

class SGiftReferralIcon extends ConsumerWidget {
  const SGiftReferralIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightGifReferralIcon();
    } else {
      return const SimpleLightGifReferralIcon();
    }
  }
}
