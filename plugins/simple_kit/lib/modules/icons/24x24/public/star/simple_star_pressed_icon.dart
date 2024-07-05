import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/star/simple_light_star_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SStarPressedIcon extends StatelessObserverWidget {
  const SStarPressedIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightStarPressedIcon(
            color: color,
          )
        : SimpleLightStarPressedIcon(
            color: color,
          );
  }
}
