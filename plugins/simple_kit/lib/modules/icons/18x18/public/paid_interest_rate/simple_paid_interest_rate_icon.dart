import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/18x18/light/paid_interest_rate/simple_light_paid_interest_rate_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPaidInterestRateIcon extends StatelessObserverWidget {
  const SPaidInterestRateIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightPaidInterestRateIcon(color: color)
        : SimpleLightPaidInterestRateIcon(color: color);
  }
}
