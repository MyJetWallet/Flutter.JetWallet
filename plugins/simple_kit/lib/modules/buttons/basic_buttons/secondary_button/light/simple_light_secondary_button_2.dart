import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/secondary_button/simple_base_secondary_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

/// Called Blue Button in UI Kit for the Light Theme
class SimpleLightSecondaryButton2 extends StatelessWidget {
  const SimpleLightSecondaryButton2({
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
    return SimpleBaseSecondaryButton(
      active: active,
      name: name,
      onTap: onTap,
      icon: icon,
      activeColor: SColorsLight().blue,
      activeNameColor: SColorsLight().blue,
      activeBackgroundColor: SColorsLight().blueLight.withOpacity(0.5),
      inactiveColor: SColorsLight().grey4,
      inactiveNameColor: SColorsLight().grey4,
      inactiveBackgroundColor: Colors.transparent,
    );
  }
}
