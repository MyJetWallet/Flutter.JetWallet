import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/angle_down/simple_light_angle_down_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAngleDownPressedIcon extends StatelessObserverWidget {
  const SAngleDownPressedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAngleDownPressedIcon()
        : const SimpleLightAngleDownPressedIcon();
  }
}
