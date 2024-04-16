import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/simple_base_text_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_dark.dart';

/// Called White Button in UI Kit for the Dark Theme
class SimpleDarkTextButton1 extends StatelessWidget {
  const SimpleDarkTextButton1({
    super.key,
    required this.active,
    required this.name,
    required this.onTap,
  });

  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseTextButton(
      active: active,
      name: name,
      onTap: onTap,
      activeColor: SColorsDark().white,
      inactiveColor: SColorsDark().grey4,
      activeBackgroundColor: SColorsDark().grey5,
    );
  }
}
