import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_profit_equal.dart';
import 'package:simple_kit/utils/enum.dart';

class SIProfitEqualIcon extends StatelessObserverWidget {
  const SIProfitEqualIcon({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestProfitEqualIcon(
            width: width,
            height: height,
          )
        : SimpleLightInvestProfitEqualIcon(
            width: width,
            height: height,
          );
  }
}
