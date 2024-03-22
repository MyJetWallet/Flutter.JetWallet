import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/40x40/light/convert/simple_light_convert_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SConvertIcon extends StatelessObserverWidget {
  const SConvertIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightConvertIcon()
        : const SimpleLightConvertIcon();
  }
}
