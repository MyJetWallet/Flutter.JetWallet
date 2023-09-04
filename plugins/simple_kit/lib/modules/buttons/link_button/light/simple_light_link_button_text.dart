import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../base/simple_base_link_button.dart';

class SimpleLightLinkButtonText extends StatelessWidget {
  const SimpleLightLinkButtonText({
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
    return SimpleBaseLinkButton(
      name: name,
      onTap: onTap,
      active: active,
      activeColor: SColorsLight().blue,
      inactiveColor: SColorsLight().grey4,
      defaultIcon: defaultIcon,
      pressedIcon: pressedIcon,
      inactiveIcon: inactiveIcon,
    );
  }
}
