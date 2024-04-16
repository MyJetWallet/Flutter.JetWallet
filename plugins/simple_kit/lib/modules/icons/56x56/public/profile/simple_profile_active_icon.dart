import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/profile/simple_light_profile_active_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SProfileActiveIcon extends StatelessObserverWidget {
  const SProfileActiveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightProfileActiveIcon()
        : const SimpleLightProfileActiveIcon();
  }
}
