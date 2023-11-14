import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/add_cash/simple_light_add_cash_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAddCashIcon extends StatelessObserverWidget {
  const SAddCashIcon({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightAddCashIcon(color: color)
        : SimpleLightAddCashIcon(color: color);
  }
}
