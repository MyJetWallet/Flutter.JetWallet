import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_profit_win.dart';
import 'package:simple_kit/utils/enum.dart';

class SIProfitWinIcon extends StatelessObserverWidget {
  const SIProfitWinIcon({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestProfitWinIcon(
            width: width,
            height: height,
          )
        : SimpleLightInvestProfitWinIcon(
            width: width,
            height: height,
          );
  }
}