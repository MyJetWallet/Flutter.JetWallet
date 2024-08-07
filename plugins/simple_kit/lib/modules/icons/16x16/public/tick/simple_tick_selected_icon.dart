import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/16x16/light/tick/simple_light_tick_selected_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class STickSelectedIcon extends StatelessObserverWidget {
  const STickSelectedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightTickSelectedIcon() : const SimpleLightTickSelectedIcon();
  }
}
