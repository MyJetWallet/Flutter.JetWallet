import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_buy.dart';
import 'package:simple_kit/utils/enum.dart';

class SIBuyIcon extends StatelessObserverWidget {
  const SIBuyIcon({
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
        ? SimpleLightInvestBuyIcon(
            color: color,
            width: width,
            height: height,
          )
        : SimpleLightInvestBuyIcon(
            color: color,
            width: width,
            height: height,
          );
  }
}
