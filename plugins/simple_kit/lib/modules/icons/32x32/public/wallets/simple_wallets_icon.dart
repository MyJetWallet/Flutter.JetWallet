import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/32x32/light/wallets/simple_light_wallets_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SWalletsActiveIcon extends StatelessObserverWidget {
  const SWalletsActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightWalletsActiveIcon()
        : const SimpleLightWalletsActiveIcon();
  }
}

class SWalletsIcon extends StatelessObserverWidget {
  const SWalletsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightWalletsDefaultIcon()
        : const SimpleLightWalletsDefaultIcon();
  }
}
