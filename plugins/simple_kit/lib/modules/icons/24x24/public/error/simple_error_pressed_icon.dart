import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/error/simple_light_error_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SErrorPressedIcon extends StatelessObserverWidget {
  const SErrorPressedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightErrorPressedIcon() : const SimpleLightErrorPressedIcon();
  }
}
