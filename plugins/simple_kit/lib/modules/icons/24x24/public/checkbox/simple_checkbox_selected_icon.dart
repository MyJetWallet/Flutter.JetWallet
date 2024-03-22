import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/checkbox/simple_light_checkbox_selected_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SCheckboxSelectedIcon extends StatelessObserverWidget {
  const SCheckboxSelectedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightCheckboxSelectedIcon()
        : const SimpleLightCheckboxSelectedIcon();
  }
}
