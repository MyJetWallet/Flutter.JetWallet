import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/recurring_buys/simple_light_recurring_buys_icon.dart';

class SRecurringBuysIcon extends ConsumerWidget {
  const SRecurringBuysIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightRecurringBuysIcon();
    } else {
      return const SimpleLightRecurringBuysIcon();
    }
  }
}
