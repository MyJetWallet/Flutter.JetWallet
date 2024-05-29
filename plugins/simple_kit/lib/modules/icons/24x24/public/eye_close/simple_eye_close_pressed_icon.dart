import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/eye_close/simple_light_eye_close_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SEyeClosePressedIcon extends StatelessObserverWidget {
  const SEyeClosePressedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightEyeClosePressedIcon()
        : const SimpleLightEyeClosePressedIcon();
  }
}
