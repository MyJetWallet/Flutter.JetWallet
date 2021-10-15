import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../current_theme_stpod.dart';
import '../light/simple_light_link_button_1.dart';

/// No dark theme for this button right now
class SLinkButton1 extends ConsumerWidget {
  const SLinkButton1({
    Key? key,
    required this.name,
    required this.onTap,
    required this.active,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool active;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightLinkButton1(
        name: name,
        onTap: onTap,
        active: active,
      );
    } else {
      return SimpleLightLinkButton1(
        name: name,
        onTap: onTap,
        active: active,
      );
    }
  }
}
