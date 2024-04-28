import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/action_receive/simple_light_action_receive_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionReceiveIcon extends StatelessObserverWidget {
  const SActionReceiveIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightActionReceiveIcon(color: color)
        : SimpleLightActionReceiveIcon(color: color);
  }
}
