import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/done/simple_light_blue_done_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SBlueDoneIcon extends StatelessObserverWidget {
  const SBlueDoneIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightBlueDoneIcon()
        : const SimpleLightBlueDoneIcon();
  }
}
