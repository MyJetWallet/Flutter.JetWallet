import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/earn/simple_light_earn_withdrawal_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SEarnWithdrawalIcon extends StatelessObserverWidget {
  const SEarnWithdrawalIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightEarnWithdrawalIcon()
        : const SimpleLightEarnWithdrawalIcon();
  }
}
