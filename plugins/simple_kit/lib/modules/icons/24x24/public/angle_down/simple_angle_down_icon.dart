import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/angle_down/simple_light_angle_down_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAngleDownIcon extends StatelessObserverWidget {
  const SAngleDownIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightAngleDownIcon(color: color)
        : SimpleLightAngleDownIcon(color: color);
  }
}
