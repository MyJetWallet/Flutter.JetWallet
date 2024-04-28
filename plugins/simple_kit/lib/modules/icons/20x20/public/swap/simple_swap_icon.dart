import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/swap/simple_light_swap_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSwapIcon extends StatelessObserverWidget {
  const SSwapIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightSwapIcon(color: color)
        : SimpleLightSwapIcon(color: color);
  }
}
