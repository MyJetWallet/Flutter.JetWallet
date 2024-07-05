import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/paused/simple_light_paused_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPausedIcon extends StatelessObserverWidget {
  const SPausedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightPausedIcon() : const SimpleLightPausedIcon();
  }
}
