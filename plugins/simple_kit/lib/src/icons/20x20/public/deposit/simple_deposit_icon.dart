import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/deposit/simple_light_deposit_icon.dart';

class SDepositIcon extends ConsumerWidget {
  const SDepositIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightDepositIcon();
    } else {
      return const SimpleLightDepositIcon();
    }
  }
}
