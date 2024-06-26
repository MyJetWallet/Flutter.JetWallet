import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/settings/simple_light_settings_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSettingsIcon extends StatelessObserverWidget {
  const SSettingsIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightSettingsIcon(color: color)
        : SimpleLightSettingsIcon(color: color);
  }
}
