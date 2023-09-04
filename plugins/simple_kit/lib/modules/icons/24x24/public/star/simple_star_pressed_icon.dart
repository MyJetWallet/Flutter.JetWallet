import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/star/simple_light_star_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SStarPressedIcon extends StatelessObserverWidget {
  const SStarPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightStarPressedIcon()
        : const SimpleLightStarPressedIcon();
  }
}
