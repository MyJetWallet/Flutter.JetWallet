import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_dark.dart';
import '../base/simple_base_secondary_button.dart';

/// Called White Button in UI Kit for the Dark Theme
class SimpleDarkSecondaryButton1 extends StatelessWidget {
  const SimpleDarkSecondaryButton1({
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
      activeColor: SColorsDark().white,
      activeNameColor: SColorsDark().white,
      activeBackgroundColor: SColorsDark().grey5,
      inactiveColor: SColorsDark().grey4,
      inactiveNameColor: SColorsDark().grey4,
      inactiveBackgroundColor: Colors.transparent,
    );
  }
}
