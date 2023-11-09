import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/cards/simple_light_mastercard_big_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMasterCardBigIcon extends StatelessObserverWidget {
  const SMasterCardBigIcon({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightMasterCardBigIcon(
            width: width,
            height: height,
          )
        : SimpleLightMasterCardBigIcon(
            width: width,
            height: height,
          );
  }
}
