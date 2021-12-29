import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_dark.dart';
import '../base/simple_base_primary_button.dart';

class SimpleDarkPrimaryButton1 extends StatelessWidget {
  const SimpleDarkPrimaryButton1({
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
    return SimpleBasePrimaryButton(
      active: active,
      name: name,
      onTap: onTap,
      icon: icon,
      activeColor: SColorsDark().white,
      activeNameColor: SColorsDark().black,
      inactiveColor: SColorsDark().grey4,
      inactiveNameColor: SColorsDark().grey2,
    );
  }
}
