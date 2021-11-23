import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/two_factor_auth/simple_light_two_factor_auth_icon.dart';

class STwoFactorAuthIcon extends ConsumerWidget {
  const STwoFactorAuthIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightTwoFactorAuthIcon();
    } else {
      return const SimpleLightTwoFactorAuthIcon();
    }
  }
}
