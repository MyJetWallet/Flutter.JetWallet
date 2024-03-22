import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/32x32/light/market/simple_light_market_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMarketActiveIcon extends StatelessObserverWidget {
  const SMarketActiveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightMarketActiveIcon()
        : const SimpleLightMarketActiveIcon();
  }
}

class SMarketIcon extends StatelessObserverWidget {
  const SMarketIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightMarketDefaultIcon()
        : const SimpleLightMarketDefaultIcon();
  }
}
