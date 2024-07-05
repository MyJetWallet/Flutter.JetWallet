import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/deposit_in_progress/simple_light_clock_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SClockIcon extends StatelessObserverWidget {
  const SClockIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightClockIcon(
            color: color,
          )
        : SimpleLightClockIcon(
            color: color,
          );
  }
}
