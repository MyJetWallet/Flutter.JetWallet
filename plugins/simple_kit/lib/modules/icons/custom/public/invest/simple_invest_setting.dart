import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/invest/simple_light_invest_setting.dart';
import 'package:simple_kit/utils/enum.dart';

class SISettingIcon extends StatelessObserverWidget {
  const SISettingIcon({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightInvestSettingIcon(
            width: width,
            height: height,
          )
        : SimpleLightInvestSettingIcon(
            width: width,
            height: height,
          );
  }
}
