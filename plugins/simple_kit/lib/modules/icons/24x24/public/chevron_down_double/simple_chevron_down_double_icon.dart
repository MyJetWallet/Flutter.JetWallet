import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/chevron_down_double/simple_light_chevron_down_double_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SChevronDownDoubleIcon extends StatelessObserverWidget {
  const SChevronDownDoubleIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightChevronDownDoubleIcon(color: color)
        : SimpleLightChevronDownDoubleIcon(color: color);
  }
}
