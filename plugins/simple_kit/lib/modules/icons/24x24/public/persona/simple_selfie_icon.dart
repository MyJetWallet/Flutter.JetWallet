import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/persona/simple_light_selfie.dart';
import 'package:simple_kit/utils/enum.dart';

class SSelfieIcon extends StatelessObserverWidget {
  const SSelfieIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightSelfieIcon(color: color)
        : SimpleLightSelfieIcon(color: color);
  }
}
