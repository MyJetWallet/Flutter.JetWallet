import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/adv_cash/simple_light_adv_cash_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAdvCashIcon extends StatelessObserverWidget {
  const SAdvCashIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAdvCashIcon()
        : const SimpleLightAdvCashIcon();
  }
}
