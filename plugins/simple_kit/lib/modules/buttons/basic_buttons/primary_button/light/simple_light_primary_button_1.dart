import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/simple_base_primary_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class SimpleLightPrimaryButton1 extends StatelessWidget {
  const SimpleLightPrimaryButton1({
    super.key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
  });

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleBasePrimaryButton(
      active: active,
      name: name,
      onTap: onTap,
      icon: icon,
      activeColor: SColorsLight().black,
      activeNameColor: SColorsLight().white,
      inactiveColor: SColorsLight().grey4,
      inactiveNameColor: SColorsLight().white,
    );
  }
}
