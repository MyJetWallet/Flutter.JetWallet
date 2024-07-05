import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/13x14/light/tick/simple_light_stats_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SStatsIcon extends StatelessObserverWidget {
  const SStatsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightStatsIcon() : const SimpleLightStatsIcon();
  }
}
