import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/angle_up/simple_light_angle_up_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAngleUpPressedIcon extends StatelessObserverWidget {
  const SAngleUpPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAngleUpPressedIcon()
        : const SimpleLightAngleUpPressedIcon();
  }
}
