import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/top_up/simple_light_top_up_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class STopUpIcon extends StatelessObserverWidget {
  const STopUpIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleLightTopUpIcon(color: color) : SimpleLightTopUpIcon(color: color);
  }
}
