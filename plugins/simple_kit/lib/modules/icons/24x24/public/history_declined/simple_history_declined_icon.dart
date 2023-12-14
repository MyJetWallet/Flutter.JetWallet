import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/history_declined/simple_light_history_declined_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SHistoryDeclinedIcon extends StatelessObserverWidget {
  const SHistoryDeclinedIcon({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightHistoryDeclinedIcon(color: color)
        : SimpleLightHistoryDeclinedIcon(color: color);
  }
}
