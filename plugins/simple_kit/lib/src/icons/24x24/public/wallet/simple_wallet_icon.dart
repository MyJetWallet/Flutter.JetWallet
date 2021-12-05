import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/wallet/simple_light_wallet_icon.dart';

class SWalletIcon extends ConsumerWidget {
  const SWalletIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightWalletIcon(
        color: color,
      );
    } else {
      return SimpleLightWalletIcon(
        color: color,
      );
    }
  }
}
