import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/cards/simple_light_wallet_card.dart';
import 'package:simple_kit/utils/enum.dart';

class SWalletCardIcon extends StatelessObserverWidget {
  const SWalletCardIcon({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightWalletCardIcon(
            width: width,
            height: height,
          )
        : SimpleLightWalletCardIcon(
            width: width,
            height: height,
          );
  }
}
