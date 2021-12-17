import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/phone/simple_light_phone_icon.dart';

class SPhoneIcon extends ConsumerWidget {
  const SPhoneIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightPhoneIcon(
        color: color,
      );
    } else {
      return SimpleLightPhoneIcon(
        color: color,
      );
    }
  }
}
