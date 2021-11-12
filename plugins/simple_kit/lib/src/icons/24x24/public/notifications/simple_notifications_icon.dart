import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/notifications/simple_notifications_icon.dart';

class SNotificationsIcon extends ConsumerWidget {
  const SNotificationsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightNotificationsIcon();
    } else {
      return const SimpleLightNotificationsIcon();
    }
  }
}
