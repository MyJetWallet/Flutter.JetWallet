import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/simple_base_primary_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_dark.dart';

class SimpleDarkPrimaryButton2 extends StatelessWidget {
  const SimpleDarkPrimaryButton2({
    super.key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
    this.isLoading = false,
  });

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SimpleBasePrimaryButton(
      active: active,
      name: name,
      onTap: onTap,
      icon: icon,
      activeColor: SColorsDark().blue,
      activeNameColor: SColorsDark().white,
      inactiveColor: SColorsDark().grey4,
      inactiveNameColor: SColorsDark().grey2,
      isLoading: isLoading,
    );
  }
}
