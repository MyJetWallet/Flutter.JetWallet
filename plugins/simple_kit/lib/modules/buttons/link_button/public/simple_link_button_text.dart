import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/buttons/link_button/light/simple_light_link_button_text.dart';
import 'package:simple_kit/simple_kit.dart';

/// No dark theme for this button right now
class SLinkButtonText extends StatelessObserverWidget {
  const SLinkButtonText({
    Key? key,
    this.defaultIcon,
    this.pressedIcon,
    this.inactiveIcon,
    required this.name,
    required this.onTap,
    required this.active,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool active;

  final Widget? defaultIcon;
  final Widget? pressedIcon;
  final Widget? inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightLinkButtonText(
            name: name,
            onTap: onTap,
            active: active,
            defaultIcon: defaultIcon,
            pressedIcon: pressedIcon,
            inactiveIcon: inactiveIcon,
          )
        : SimpleLightLinkButtonText(
            name: name,
            onTap: onTap,
            active: active,
            defaultIcon: defaultIcon,
            pressedIcon: pressedIcon,
            inactiveIcon: inactiveIcon,
          );
  }
}
