import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/list_checkmark/simple_light_minus_list_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SMinusListIcon extends StatelessObserverWidget {
  const SMinusListIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightMinusListIcon(color: color)
        : SimpleLightMinusListIcon(color: color);
  }
}
