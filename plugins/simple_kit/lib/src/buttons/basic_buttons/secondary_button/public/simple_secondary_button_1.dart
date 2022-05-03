import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../dark/simple_dark_secondary_button_1.dart';
import '../light/simple_light_secondary_button_1.dart';

class SSecondaryButton1 extends ConsumerWidget {
  const SSecondaryButton1({
    Key? key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleDarkSecondaryButton1(
        active: active,
        name: name,
        icon: icon,
        onTap: onTap,
      );
    } else {
      return SimpleLightSecondaryButton1(
        active: active,
        name: name,
        icon: icon,
        onTap: onTap,
      );
    }
  }
}
