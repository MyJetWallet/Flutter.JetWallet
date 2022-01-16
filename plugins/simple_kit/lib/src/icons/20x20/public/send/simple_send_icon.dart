import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/send/simple_light_send_icon.dart';

class SSendIcon extends ConsumerWidget {
  const SSendIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSendIcon();
    } else {
      return const SimpleLightSendIcon();
    }
  }
}
