import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/info/simple_light_info_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SInfoIcon extends StatelessObserverWidget {
  const SInfoIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInfoIcon(color: color)
        : SimpleLightInfoIcon(color: color);
  }
}
