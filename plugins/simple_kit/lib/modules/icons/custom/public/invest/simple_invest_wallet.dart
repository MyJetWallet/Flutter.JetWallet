import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_wallet.dart';
import 'package:simple_kit/utils/enum.dart';

class SIWalletIcon extends StatelessObserverWidget {
  const SIWalletIcon({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestWalletIcon(
            width: width,
            height: height,
          )
        : SimpleLightInvestWalletIcon(
            width: width,
            height: height,
          );
  }
}
