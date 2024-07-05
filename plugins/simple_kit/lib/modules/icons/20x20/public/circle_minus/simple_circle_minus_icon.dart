import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/circle_minus/simple_light_circle_minus.dart';
import 'package:simple_kit/utils/enum.dart';

class SCircleMinusIcon extends StatelessObserverWidget {
  const SCircleMinusIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightCircleMinusIcon() : const SimpleLightCircleMinusIcon();
  }
}
