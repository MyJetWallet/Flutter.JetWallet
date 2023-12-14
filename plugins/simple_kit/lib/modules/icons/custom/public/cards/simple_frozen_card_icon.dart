import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/cards/simple_light_card_frozen_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SFrozenCardIcon extends StatelessObserverWidget {
  const SFrozenCardIcon({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightCardFrozenIcon(
            width: width,
            height: height,
          )
        : SimpleLightCardFrozenIcon(
            width: width,
            height: height,
          );
  }
}
