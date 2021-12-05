import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/fee_alert/simple_light_fee_alert_icon.dart';

class SFeeAlertIcon extends ConsumerWidget {
  const SFeeAlertIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightFeeAlertIcon();
    } else {
      return const SimpleLightFeeAlertIcon();
    }
  }
}
