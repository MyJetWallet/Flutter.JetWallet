import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_sell.dart';
import 'package:simple_kit/utils/enum.dart';

class SISellIcon extends StatelessObserverWidget {
  const SISellIcon({
    Key? key,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestSellIcon(
            color: color,
            width: width,
            height: height,
          )
        : SimpleLightInvestSellIcon(
            color: color,
            width: width,
            height: height,
          );
  }
}
