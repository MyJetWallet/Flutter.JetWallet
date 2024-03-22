import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/16x16/light/gift_history/simple_light_gift_history_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SGiftHistoryIcon extends StatelessWidget {
  const SGiftHistoryIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightGiftHistoryIcon(color: color)
        : SimpleLightGiftHistoryIcon(color: color);
  }
}
