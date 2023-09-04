import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/40x40/light/convert/simple_light_convert_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SConvertPressedIcon extends StatelessObserverWidget {
  const SConvertPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightConvertPressedIcon()
        : const SimpleLightConvertPressedIcon();
  }
}
