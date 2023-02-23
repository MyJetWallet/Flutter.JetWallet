import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/simple_base_text_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

/// Called Black Button in UI Kit for the Light Theme
class SimpleLightTextButton1 extends StatelessWidget {
  const SimpleLightTextButton1({
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
    return SimpleBaseTextButton(
      active: active,
      name: name,
      onTap: onTap,
      activeColor: SColorsLight().blue,
      inactiveColor: SColorsLight().grey4,
      activeBackgroundColor: SColorsLight().grey5.withOpacity(0.5),
    );
  }
}
