import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/simple_base_text_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

/// Called Blue Button in UI Kit for the Light Theme
class SimpleLightTextButton2 extends StatelessWidget {
  const SimpleLightTextButton2({
    super.key,
    this.icon,
    this.addPadding = false,
    this.autoSize = false,
    required this.active,
    required this.name,
    required this.onTap,
  });

  final Widget? icon;
  final bool active;
  final bool addPadding;
  final bool autoSize;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseTextButton(
      addPadding: addPadding,
      autoSize: autoSize,
      icon: icon,
      active: active,
      name: name,
      onTap: onTap,
      activeColor: SColorsLight().blue,
      inactiveColor: SColorsLight().grey4,
      activeBackgroundColor: SColorsLight().blueLight.withOpacity(0.5),
    );
  }
}
