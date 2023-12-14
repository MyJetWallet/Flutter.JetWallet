import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/start_reorder/simple_light_start_reorder_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SStartReorderIcon extends StatelessObserverWidget {
  const SStartReorderIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightStartReorderIcon(color: color)
        : SimpleLightStartReorderIcon(color: color);
  }
}
