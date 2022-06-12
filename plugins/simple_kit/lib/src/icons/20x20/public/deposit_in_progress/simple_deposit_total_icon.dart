import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/deposit_in_progress/simple_light_deposit_in_progress_total_icon.dart';

class SDepositTotalIcon extends ConsumerWidget {
  const SDepositTotalIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightDepositInProgressTotalIcon();
    } else {
      return const SimpleLightDepositInProgressTotalIcon();
    }
  }
}
