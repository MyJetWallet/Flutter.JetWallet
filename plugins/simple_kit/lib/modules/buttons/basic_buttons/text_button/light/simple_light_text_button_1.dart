import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/simple_base_text_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

/// Called Black Button in UI Kit for the Light Theme
class SimpleLightTextButton1 extends StatelessWidget {
  const SimpleLightTextButton1({
    Key? key,
    this.color,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final String name;
  final Function() onTap;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    late Color activeColor;

    activeColor =
        color != null ? color ?? SColorsLight().black : SColorsLight().black;

    return SimpleBaseTextButton(
      active: active,
      name: name,
      onTap: onTap,
      activeColor: activeColor,
      inactiveColor: SColorsLight().grey4,
      activeBackgroundColor: SColorsLight().grey3.withOpacity(0.3),
    );
  }
}
