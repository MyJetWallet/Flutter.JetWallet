import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/checkmark/simple_light_checkmark.dart';
import 'package:simple_kit/utils/enum.dart';

class SCheckmarkIcon extends StatelessObserverWidget {
  const SCheckmarkIcon({
    super.key,
    required this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightCheckmarkIcon(
            color: color,
          )
        : SimpleLightCheckmarkIcon(
            color: color,
          );
  }
}
