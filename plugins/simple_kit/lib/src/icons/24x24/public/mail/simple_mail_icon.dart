import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/mail/simple_light_mail_icon.dart';

class SMailIcon extends ConsumerWidget {
  const SMailIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightMailIcon();
    } else {
      return const SimpleLightMailIcon();
    }
  }
}
