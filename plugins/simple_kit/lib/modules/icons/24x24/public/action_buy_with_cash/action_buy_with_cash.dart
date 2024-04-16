import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/action_buy_with_cash/action_buy_with_cash.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionBuytWithCashIcon extends StatelessObserverWidget {
  const SActionBuytWithCashIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightBuytWithCashIcon(color: color)
        : SimpleLightBuytWithCashIcon(color: color);
  }
}
