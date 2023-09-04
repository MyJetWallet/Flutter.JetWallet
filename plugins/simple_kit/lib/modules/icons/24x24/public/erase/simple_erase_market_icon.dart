import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/erase/simple_light_erase_market.dart';
import 'package:simple_kit/utils/enum.dart';

class SEraseMarketIcon extends StatelessObserverWidget {
  const SEraseMarketIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightEraseMarketIcon()
        : const SimpleLightEraseMarketIcon();
  }
}
