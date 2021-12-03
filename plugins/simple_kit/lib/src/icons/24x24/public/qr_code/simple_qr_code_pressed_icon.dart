import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/qr_code/simple_light_qr_code_pressed_icon.dart';

class SQrCodePressedIcon extends ConsumerWidget {
  const SQrCodePressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightQrCodePressedIcon();
    } else {
      return const SimpleLightQrCodePressedIcon();
    }
  }
}
