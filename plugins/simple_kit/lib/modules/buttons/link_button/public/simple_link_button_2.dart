import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import '../light/simple_light_link_button_2.dart';

/// No dark theme for this button right now
class SLinkButton2 extends StatelessObserverWidget {
  const SLinkButton2({
    super.key,
    required this.name,
    required this.onTap,
    required this.active,
  });

  final String name;
  final Function() onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightLinkButton2(
            name: name,
            onTap: onTap,
            active: active,
          )
        : SimpleLightLinkButton2(
            name: name,
            onTap: onTap,
            active: active,
          );
  }
}
