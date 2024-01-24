import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_sort_down.dart';
import 'package:simple_kit/utils/enum.dart';

class SISortDownIcon extends StatelessObserverWidget {
  const SISortDownIcon({
    Key? key,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestSortDownIcon(
            color: color,
            width: width,
            height: height,
          )
        : SimpleLightInvestSortDownIcon(
            color: color,
            width: width,
            height: height,
          );
  }
}
