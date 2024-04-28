import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/action_buy/simple_light_action_buy_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionBuyIcon extends StatelessObserverWidget {
  const SActionBuyIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightActionBuyIcon(color: color)
        : SimpleLightActionBuyIcon(color: color);
  }
}
