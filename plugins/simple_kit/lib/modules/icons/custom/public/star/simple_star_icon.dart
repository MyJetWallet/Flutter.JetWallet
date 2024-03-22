import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/star/simple_light_star.dart';
import 'package:simple_kit/utils/enum.dart';

class SRewardStarIcon extends StatelessObserverWidget {
  const SRewardStarIcon({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightRewardStarIcon(
            width: width,
            height: height,
          )
        : SimpleLightRewardStarIcon(
            width: width,
            height: height,
          );
  }
}
