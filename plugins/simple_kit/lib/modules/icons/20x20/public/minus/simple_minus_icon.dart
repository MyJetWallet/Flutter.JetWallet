import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/minus/simple_light_minus_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMinusIcon extends StatelessObserverWidget {
  const SMinusIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleLightMinusIcon(color: color) : SimpleLightMinusIcon(color: color);
  }
}
