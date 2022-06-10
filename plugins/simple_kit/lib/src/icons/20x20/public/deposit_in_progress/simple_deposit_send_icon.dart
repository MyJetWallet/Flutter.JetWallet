import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/deposit_in_progress/simple_light_deposit_in_progress_send_icon.dart';

class SDepositSendIcon extends ConsumerWidget {
  const SDepositSendIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightDepositInProgressSendIcon();
    } else {
      return const SimpleLightDepositInProgressSendIcon();
    }
  }
}
