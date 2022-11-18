import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/complete/simple_light_complete_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SCompleteIcon extends StatelessObserverWidget {
  const SCompleteIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightCompleteIcon(color: color)
        : SimpleLightCompleteIcon(color: color);
  }
}
