import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/action_sell/simple_light_action_sell_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionSellIcon extends StatelessObserverWidget {
  const SActionSellIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightActionSellIcon() : const SimpleLightActionSellIcon();
  }
}
