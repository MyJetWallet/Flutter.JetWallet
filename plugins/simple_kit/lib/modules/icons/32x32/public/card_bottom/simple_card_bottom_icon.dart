import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/32x32/light/card_bottom/simple_light_card_bottom_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SCardBottomActiveIcon extends StatelessObserverWidget {
  const SCardBottomActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightCardBottomActiveIcon()
        : const SimpleLightCardBottomActiveIcon();
  }
}

class SCardBottomIcon extends StatelessObserverWidget {
  const SCardBottomIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightCardBottomDefaultIcon()
        : const SimpleLightCardBottomDefaultIcon();
  }
}
