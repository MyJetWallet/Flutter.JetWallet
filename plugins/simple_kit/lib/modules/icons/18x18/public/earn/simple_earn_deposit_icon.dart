import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/18x18/light/earn/simple_light_earn_deposit_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SEarnDepositIcon extends StatelessObserverWidget {
  const SEarnDepositIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightEarnDepositIcon(color: color)
        : SimpleLightEarnDepositIcon(color: color);
  }
}
