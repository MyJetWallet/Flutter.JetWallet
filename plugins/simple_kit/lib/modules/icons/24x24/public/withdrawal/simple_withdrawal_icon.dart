import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/withdrawal/simple_light_withdrawal_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SWithdrawalIcon extends StatelessObserverWidget {
  const SWithdrawalIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightWithdrawalIcon(color: color)
        : SimpleLightWithdrawalIcon(color: color);
  }
}
