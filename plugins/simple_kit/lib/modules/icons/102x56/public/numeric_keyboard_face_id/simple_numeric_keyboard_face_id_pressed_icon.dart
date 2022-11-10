import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/102x56/light/numeric_keyboard_face_id/simple_light_numeric_keyboard_face_id_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SNumericKeyboardFaceIdPressedIcon extends StatelessObserverWidget {
  const SNumericKeyboardFaceIdPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightNumericKeyboardFaceIdPressedIcon()
        : const SimpleLightNumericKeyboardFaceIdPressedIcon();
  }
}
