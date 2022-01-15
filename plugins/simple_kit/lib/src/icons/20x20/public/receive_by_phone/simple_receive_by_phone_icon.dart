import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/receive_by_phone/simple_light_receive_by_phone_icon.dart';

class SReceiveByPhoneIcon extends ConsumerWidget {
  const SReceiveByPhoneIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightReceiveByPhoneIcon();
    } else {
      return const SimpleLightReceiveByPhoneIcon();
    }
  }
}
