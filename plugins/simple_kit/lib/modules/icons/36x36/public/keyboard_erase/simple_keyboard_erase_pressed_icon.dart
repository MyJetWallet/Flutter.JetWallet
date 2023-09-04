import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/36x36/light/keyboard_erase/simple_light_keyboard_erase_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SKeyboardErasePressedIcon extends StatelessObserverWidget {
  const SKeyboardErasePressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightKeyboardErasePressedIcon()
        : const SimpleLightKeyboardErasePressedIcon();
  }
}
