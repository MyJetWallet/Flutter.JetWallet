import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/102x56/light/numeric_keyboard_fingerprint/simple_light_numeric_keyboard_fingerprint_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SNumericKeyboardFingerprintPressedIcon extends StatelessObserverWidget {
  const SNumericKeyboardFingerprintPressedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightNumericKeyboardFingerprintPressedIcon()
        : const SimpleLightNumericKeyboardFingerprintPressedIcon();
  }
}
