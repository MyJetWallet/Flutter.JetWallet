import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/cards/simple_light_mastercard_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMasterCardIcon extends StatelessObserverWidget {
  const SMasterCardIcon({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightMasterCardIcon(
            width: width,
            height: height,
          )
        : SimpleLightMasterCardIcon(
            width: width,
            height: height,
          );
  }
}
