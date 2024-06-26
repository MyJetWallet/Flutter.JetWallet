import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/reorder/simple_light_reorder_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SReorderIcon extends StatelessObserverWidget {
  const SReorderIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightReorderIcon(color: color)
        : SimpleLightReorderIcon(color: color);
  }
}
