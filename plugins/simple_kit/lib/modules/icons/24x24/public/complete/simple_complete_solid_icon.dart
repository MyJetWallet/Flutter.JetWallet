import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/icons/24x24/light/complete/simple_light_complete_solid_icon.dart';
import 'package:simple_kit/simple_kit.dart';

class SCompleteSolidIcon extends StatelessObserverWidget {
  const SCompleteSolidIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightCompleteSolidIcon()
        : const SimpleLightCompleteSolidIcon();
  }
}
