import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/simple_base_primary_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_dark.dart';

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
