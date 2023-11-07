import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/simple_card_actions/simple_light_terminate_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class STerminateIcon extends StatelessObserverWidget {
  const STerminateIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightTerminateIcon(color: color)
        : SimpleLightTerminateIcon(color: color);
  }
}
