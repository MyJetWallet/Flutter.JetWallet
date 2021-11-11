import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/security/simple_light_security_icon.dart';

class SSecurityIcon extends ConsumerWidget {
  const SSecurityIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSecurityIcon();
    } else {
      return const SimpleLightSecurityIcon();
    }
  }
}
