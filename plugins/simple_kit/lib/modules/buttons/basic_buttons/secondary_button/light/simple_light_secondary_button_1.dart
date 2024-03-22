import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/secondary_button/simple_base_secondary_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

/// Called Black Button in UI Kit for the Light Theme
class SimpleLightSecondaryButton1 extends StatelessWidget {
  const SimpleLightSecondaryButton1({
    super.key,
    this.icon,
    this.textColor,
    this.borderColor,
    required this.active,
    required this.name,
    required this.onTap,
  });

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;

  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSecondaryButton(
      active: active,
      name: name,
      onTap: onTap,
      icon: icon,
      activeColor: borderColor ?? SColorsLight().black,
      activeNameColor: textColor ?? SColorsLight().black,
      activeBackgroundColor: SColorsLight().grey5,
      inactiveColor: SColorsLight().grey4,
      inactiveNameColor: SColorsLight().grey4,
      inactiveBackgroundColor: Colors.transparent,
    );
  }
}
