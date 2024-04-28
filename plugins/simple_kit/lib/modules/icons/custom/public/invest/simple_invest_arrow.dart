import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_arrow.dart';
import 'package:simple_kit/utils/enum.dart';

class SIArrowIcon extends StatelessObserverWidget {
  const SIArrowIcon({
    super.key,
    this.color,
    this.width,
    this.height,
  });

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestArrowIcon(
            color: color,
            width: width,
            height: height,
          )
        : SimpleLightInvestArrowIcon(
            color: color,
            width: width,
            height: height,
          );
  }
}
