import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/action_deposit/simple_light_action_deposit_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionDepositIcon extends StatelessObserverWidget {
  const SActionDepositIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightActionDepositIcon(color: color)
        : SimpleLightActionDepositIcon(color: color);
  }
}
