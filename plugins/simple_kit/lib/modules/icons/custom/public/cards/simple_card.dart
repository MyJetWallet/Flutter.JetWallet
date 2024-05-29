import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/cards/simple_light_card.dart';
import 'package:simple_kit/utils/enum.dart';

class SCardIcon extends StatelessObserverWidget {
  const SCardIcon({
    super.key,
    this.width,
    this.height,
    this.color,
  });

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightCardIcon(
            width: width,
            height: height,
            color: color,
          )
        : SimpleLightCardIcon(
            width: width,
            height: height,
            color: color,
          );
  }
}
