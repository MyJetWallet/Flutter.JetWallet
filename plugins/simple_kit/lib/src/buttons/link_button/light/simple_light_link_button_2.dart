import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../../../icons/light/mail/simple_light_mail_icon.dart';
import '../../../icons/light/mail/simple_light_mail_pressed_icon.dart';
import '../base/simple_base_link_button.dart';

class SimpleLightLinkButton2 extends StatelessWidget {
  const SimpleLightLinkButton2({
    Key? key,
    required this.name,
    required this.onTap,
    required this.active,
  }) : super(key: key);

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
      defaultIcon: SLightMailIcon(
        color: SColorsLight().blue,
      ),
      pressedIcon: SLightMailPressedIcon(
        color: SColorsLight().blue,
      ),
      inactiveIcon: SLightMailIcon(
        color: SColorsLight().grey4,
      ),
    );
  }
}
