import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/eye_close/simple_light_eye_close_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SEyeCloseIcon extends StatelessObserverWidget {
  const SEyeCloseIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightEyeCloseIcon(color: color)
        : SimpleLightEyeCloseIcon(color: color);
  }
}
