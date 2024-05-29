import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/market/simple_light_market_default_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMarketDefaultIcon extends StatelessObserverWidget {
  const SMarketDefaultIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightMarketDefaultIcon()
        : const SimpleLightMarketDefaultIcon();
  }
}
