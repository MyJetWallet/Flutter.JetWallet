import 'package:flutter/material.dart';

import '../../../colors/view/simple_colors_dark.dart';
import '../base/simple_base_text_button.dart';

/// Called White Button in UI Kit for the Dark Theme
class SimpleDarkTextButton1 extends StatelessWidget {
  const SimpleDarkTextButton1({
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
      activeColor: SColorsDark().white,
      inactiveColor: SColorsDark().grey4,
    );
  }
}
