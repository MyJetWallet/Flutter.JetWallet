import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/cash/simple_light_cash_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SCasheIcon extends StatelessObserverWidget {
  const SCasheIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleLightCashIcon(color: color) : SimpleLightCashIcon(color: color);
  }
}
