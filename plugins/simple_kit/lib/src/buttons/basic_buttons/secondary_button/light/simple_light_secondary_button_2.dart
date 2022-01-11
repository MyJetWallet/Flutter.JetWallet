import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_light.dart';
import '../base/simple_base_secondary_button.dart';

/// Called Blue Button in UI Kit for the Light Theme
class SimpleLightSecondaryButton2 extends StatelessWidget {
  const SimpleLightSecondaryButton2({
    Key? key,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSecondaryButton(
      active: active,
      name: name,
      onTap: onTap,
      activeColor: SColorsLight().blue,
      activeNameColor: SColorsLight().blue,
      inactiveColor: SColorsLight().grey4,
      inactiveNameColor: SColorsLight().grey4,
    );
  }
}
