import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/simple_card_actions/simple_light_card_settings_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SCardSettingsIcon extends StatelessObserverWidget {
  const SCardSettingsIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightCardSettingsIcon(color: color)
        : SimpleLightCardSettingsIcon(color: color);
  }
}
