import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../current_theme_stpod.dart';
import '../light/simple_light_link_button_2.dart';

/// No dark theme for this button right now
class SLinkButton2 extends ConsumerWidget {
  const SLinkButton2({
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
      return SimpleLightLinkButton2(
        name: name,
        onTap: onTap,
        active: active,
      );
    } else {
      return SimpleLightLinkButton2(
        name: name,
        onTap: onTap,
        active: active,
      );
    }
  }
}
