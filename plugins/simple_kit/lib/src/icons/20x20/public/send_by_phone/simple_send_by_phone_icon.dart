import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/send_by_phone/simple_light_send_by_phone_icon.dart';

class SSendByPhoneIcon extends ConsumerWidget {
  const SSendByPhoneIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSendByPhoneIcon();
    } else {
      return const SimpleLightSendByPhoneIcon();
    }
  }
}
