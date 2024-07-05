import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/plus/simple_light_plus_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPlusIcon extends StatelessObserverWidget {
  const SPlusIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleLightPlusIcon(color: color) : SimpleLightPlusIcon(color: color);
  }
}
