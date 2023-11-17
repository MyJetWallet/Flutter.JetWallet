import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/16x16/light/reward_history/simple_light_reward_history_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SRewardHistoryIcon extends StatelessWidget {
  const SRewardHistoryIcon({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightRewardHistoryIcon(color: color)
        : SimpleLightRewardHistoryIcon(color: color);
  }
}
