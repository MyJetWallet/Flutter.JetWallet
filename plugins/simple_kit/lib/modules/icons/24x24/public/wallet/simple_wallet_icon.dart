import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/wallet/simple_light_wallet_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SWalletIcon extends StatelessObserverWidget {
  const SWalletIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightWalletIcon(color: color)
        : SimpleLightWalletIcon(color: color);
  }
}

class SWallet2Icon extends StatelessObserverWidget {
  const SWallet2Icon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightWallet2Icon(color: color)
        : SimpleLightWallet2Icon(color: color);
  }
}
