import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/qr_code/simple_light_qr_code_icon.dart';

class SQrCodeIcon extends ConsumerWidget {
  const SQrCodeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightQrCodeIcon();
    } else {
      return const SimpleLightQrCodeIcon();
    }
  }
}
