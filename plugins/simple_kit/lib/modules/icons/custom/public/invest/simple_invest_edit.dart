import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_edit.dart';
import 'package:simple_kit/utils/enum.dart';

class SIEditIcon extends StatelessObserverWidget {
  const SIEditIcon({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestEditIcon(
            width: width,
            height: height,
          )
        : SimpleLightInvestEditIcon(
            width: width,
            height: height,
          );
  }
}
