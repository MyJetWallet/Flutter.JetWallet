import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/reward/simple_light_reward_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SRewardIcon extends StatelessObserverWidget {
  const SRewardIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleLightRewardIcon(color: color) : SimpleLightRewardIcon(color: color);
  }
}
