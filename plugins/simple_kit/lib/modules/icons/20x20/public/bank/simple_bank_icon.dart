import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/bank/simple_light_bank.dart';
import 'package:simple_kit/utils/enum.dart';

class SBankIcon extends StatelessObserverWidget {
  const SBankIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightBankMinusIcon(color: color)
        : SimpleLightBankMinusIcon(color: color);
  }
}
