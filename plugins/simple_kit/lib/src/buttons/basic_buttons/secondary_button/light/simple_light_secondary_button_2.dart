import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_light.dart';
import '../base/simple_base_secondary_button.dart';

/// Called Blue Button in UI Kit for the Light Theme
class SimpleLightSecondaryButton2 extends StatelessWidget {
  const SimpleLightSecondaryButton2({
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
