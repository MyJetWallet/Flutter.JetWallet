import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/close/simple_light_close_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SClosePressedIcon extends StatelessObserverWidget {
  const SClosePressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightClosePressedIcon()
        : const SimpleLightClosePressedIcon();
  }
}
