import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/fingerprint/simple_light_fingerprint_icon.dart';

class SFingerprintIcon extends ConsumerWidget {
  const SFingerprintIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightFingerprintIcon();
    } else {
      return const SimpleLightFingerprintIcon();
    }
  }
}
