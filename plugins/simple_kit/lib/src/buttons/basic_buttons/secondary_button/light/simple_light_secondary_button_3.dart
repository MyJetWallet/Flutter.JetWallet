import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_light.dart';
import '../base/simple_base_secondary_button1.dart';

/// Called Black Button in UI Kit for the Light Theme
class SimpleLightSecondaryButton3 extends StatelessWidget {
  const SimpleLightSecondaryButton3({
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
    return SimpleBaseSecondaryButton2(
      active: active,
      name: name,
      onTap: onTap,
      icon: icon,
      activeColor: SColorsLight().black,
      activeNameColor: SColorsLight().black,
      activeBackgroundColor: SColorsLight().black.withOpacity(0.1),
      inactiveColor: SColorsLight().grey4,
      inactiveNameColor: SColorsLight().grey4,
      inactiveBackgroundColor: Colors.transparent,
    );
  }
}
