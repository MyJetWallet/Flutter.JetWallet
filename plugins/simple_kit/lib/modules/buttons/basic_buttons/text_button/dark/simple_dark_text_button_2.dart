import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/simple_base_text_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_dark.dart';

/// Called Blue Button in UI Kit for the Dark Theme
class SimpleDarkTextButton2 extends StatelessWidget {
  const SimpleDarkTextButton2({
    Key? key,
    this.icon,
    this.addPadding = false,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Widget? icon;
  final bool addPadding;
  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseTextButton(
      addPadding: addPadding,
      icon: icon,
      active: active,
      name: name,
      onTap: onTap,
      activeColor: SColorsDark().blue,
      inactiveColor: SColorsDark().grey4,
      activeBackgroundColor: SColorsDark().blueLight.withOpacity(0.5),
    );
  }
}
