import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/filter/simple_light_pressed_filter_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPressedFilterIcon extends StatelessObserverWidget {
  const SPressedFilterIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightPressedFilterIcon(color: color)
        : SimpleLightPressedFilterIcon(color: color);
  }
}
