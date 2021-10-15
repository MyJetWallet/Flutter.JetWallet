import 'package:flutter/material.dart';

import '../../../colors/view/simple_colors_dark.dart';
import '../base/simple_base_primary_button.dart';

class SimpleDarkPrimaryButton1 extends StatelessWidget {
  const SimpleDarkPrimaryButton1({
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
    return SimpleBasePrimaryButton(
      active: active,
      name: name,
      onTap: onTap,
      activeColor: SColorsDark().white,
      activeNameColor: SColorsDark().black,
      inactiveColor: SColorsDark().grey4,
      inactiveNameColor: SColorsDark().grey2,
    );
  }
}
