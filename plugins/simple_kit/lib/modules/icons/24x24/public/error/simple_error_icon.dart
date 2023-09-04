import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/error/simple_light_error_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SErrorIcon extends StatelessObserverWidget {
  const SErrorIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightErrorIcon(color: color)
        : SimpleLightErrorIcon(color: color);
  }
}
