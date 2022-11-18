import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/deposit/simple_light_deposit_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SDepositIcon extends StatelessObserverWidget {
  const SDepositIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightDepositIcon(color: color)
        : SimpleLightDepositIcon(color: color);
  }
}
