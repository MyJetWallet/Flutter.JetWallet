import 'package:flutter/material.dart';

import '../../../colors/view/simple_colors_dark.dart';
import '../base/simple_base_secondary_button.dart';

/// Called Blue Button in UI Kit for the Dark Theme
class SimpleDarkSecondaryButton2 extends StatelessWidget {
  const SimpleDarkSecondaryButton2({
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
      activeColor: SColorsDark().blue,
      activeNameColor: SColorsDark().blue,
      inactiveColor: SColorsDark().grey4,
      inactiveNameColor: SColorsDark().grey4,
    );
  }
}
