import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/filter/simple_light_filter_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SFilterIcon extends StatelessObserverWidget {
  const SFilterIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightFilterIcon(color: color)
        : SimpleLightFilterIcon(color: color);
  }
}
