import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_dark.dart';
import '../base/simple_base_secondary_button1.dart';

/// Called White Button in UI Kit for the Dark Theme
class SimpleDarkSecondaryButton3 extends StatelessWidget {
  const SimpleDarkSecondaryButton3({
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
      activeColor: SColorsDark().white,
      activeNameColor: SColorsDark().white,
      activeBackgroundColor: SColorsDark().black.withOpacity(0.1),
      inactiveColor: SColorsDark().grey4,
      inactiveNameColor: SColorsDark().grey4,
      inactiveBackgroundColor: Colors.transparent,
    );
  }
}
