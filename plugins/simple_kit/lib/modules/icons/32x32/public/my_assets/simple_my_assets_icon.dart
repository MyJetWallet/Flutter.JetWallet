import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/32x32/light/my_assets/simple_light_my_assets_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMyAssetsActiveIcon extends StatelessObserverWidget {
  const SMyAssetsActiveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightMyAssetsActiveIcon()
        : const SimpleLightMyAssetsActiveIcon();
  }
}

class SMyAssetsIcon extends StatelessObserverWidget {
  const SMyAssetsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightMyAssetsDefaultIcon()
        : const SimpleLightMyAssetsDefaultIcon();
  }
}
