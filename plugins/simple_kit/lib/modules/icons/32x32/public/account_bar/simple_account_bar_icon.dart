import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/32x32/light/account_bar/simple_light_account_bar_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAccountBarActiveIcon extends StatelessObserverWidget {
  const SAccountBarActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAccountBarActiveIcon()
        : const SimpleLightAccountBarActiveIcon();
  }
}

class SAccountBarIcon extends StatelessObserverWidget {
  const SAccountBarIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAccountBarDefaultIcon()
        : const SimpleLightAccountBarDefaultIcon();
  }
}
