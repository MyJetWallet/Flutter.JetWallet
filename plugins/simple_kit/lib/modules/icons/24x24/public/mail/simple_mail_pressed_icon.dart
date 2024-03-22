import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/mail/simple_light_mail_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMailPressedIcon extends StatelessObserverWidget {
  const SMailPressedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightMailPressedIcon()
        : const SimpleLightMailPressedIcon();
  }
}
