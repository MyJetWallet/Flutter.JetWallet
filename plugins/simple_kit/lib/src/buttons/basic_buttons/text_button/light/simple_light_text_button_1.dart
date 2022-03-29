import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_light.dart';
import '../base/simple_base_text_button.dart';

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
      activeColor: SColorsLight().black,
      inactiveColor: SColorsLight().grey4,
      activeBackgroundColor: SColorsLight().grey5.withOpacity(0.5),
    );
  }
}
