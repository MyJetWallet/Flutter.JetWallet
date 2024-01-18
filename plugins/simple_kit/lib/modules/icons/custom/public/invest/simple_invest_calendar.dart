import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_calendar.dart';
import 'package:simple_kit/utils/enum.dart';

class SICalendarIcon extends StatelessObserverWidget {
  const SICalendarIcon({
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
        ? SimpleLightInvestCalendarIcon(
            color: color,
            width: width,
            height: height,
          )
        : SimpleLightInvestCalendarIcon(
            color: color,
            width: width,
            height: height,
          );
  }
}
