import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../base/simple_base_link_button.dart';

class SimpleLightLinkButtonText extends StatelessWidget {
  const SimpleLightLinkButtonText({
    super.key,
    this.defaultIcon,
    this.pressedIcon,
    this.inactiveIcon,
    this.activeColor,
    this.inactiveColor,
    this.textStyle,
    this.mainAxisAlignment,
    required this.name,
    required this.onTap,
    required this.active,
  });

  final String name;
  final Function() onTap;
  final bool active;

  final Color? activeColor;
  final Color? inactiveColor;
  final TextStyle? textStyle;
  final MainAxisAlignment? mainAxisAlignment;

  final Widget? defaultIcon;
  final Widget? pressedIcon;
  final Widget? inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseLinkButton(
      name: name,
      onTap: onTap,
      active: active,
      activeColor: activeColor ?? SColorsLight().blue,
      inactiveColor: inactiveColor ?? SColorsLight().grey4,
      defaultIcon: defaultIcon,
      pressedIcon: pressedIcon,
      inactiveIcon: inactiveIcon,
      textStyle: textStyle,
      mainAxisAlignment: mainAxisAlignment,
    );
  }
}
