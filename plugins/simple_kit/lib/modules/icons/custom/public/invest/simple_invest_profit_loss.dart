import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_profit_loss.dart';
import 'package:simple_kit/utils/enum.dart';

class SIProfitLossIcon extends StatelessObserverWidget {
  const SIProfitLossIcon({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestProfitLossIcon(
            width: width,
            height: height,
          )
        : SimpleLightInvestProfitLossIcon(
            width: width,
            height: height,
          );
  }
}
