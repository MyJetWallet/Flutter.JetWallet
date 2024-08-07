import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/angle_up/simple_light_angle_up_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAngleUpIcon extends StatelessObserverWidget {
  const SAngleUpIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightAngleUpIcon() : const SimpleLightAngleUpIcon();
  }
}
