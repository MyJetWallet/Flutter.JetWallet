import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../icons/24x24/light/mail/simple_light_mail_icon.dart';
import '../../../icons/24x24/light/mail/simple_light_mail_pressed_icon.dart';
import '../base/simple_base_link_button.dart';

class SimpleLightLinkButton2 extends StatelessWidget {
  const SimpleLightLinkButton2({
    super.key,
    required this.name,
    required this.onTap,
    required this.active,
  });

  final String name;
  final Function() onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseLinkButton(
      name: name,
      onTap: onTap,
      active: active,
      activeColor: SColorsLight().blue,
      inactiveColor: SColorsLight().grey4,
      defaultIcon: SimpleLightMailIcon(
        color: SColorsLight().blue,
      ),
      pressedIcon: SimpleLightMailPressedIcon(
        color: SColorsLight().blue,
      ),
      inactiveIcon: SimpleLightMailIcon(
        color: SColorsLight().grey4,
      ),
    );
  }
}
