import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/rewards/simple_rewards_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SRewardTrophyIcon extends StatelessObserverWidget {
  const SRewardTrophyIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleRewardsTrophyIcon(color: color)
        : SimpleRewardsTrophyIcon(color: color);
  }
}
