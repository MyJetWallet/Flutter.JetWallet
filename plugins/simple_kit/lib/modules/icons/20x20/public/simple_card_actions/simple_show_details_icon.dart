import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/simple_card_actions/simple_light_show_details_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SShowDetailsIcon extends StatelessObserverWidget {
  const SShowDetailsIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightShowDetailsIcon(color: color)
        : SimpleLightShowDetailsIcon(color: color);
  }
}
