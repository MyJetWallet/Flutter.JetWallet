import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/profile/simple_light_profile_default_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SProfileDefaultIcon extends StatelessObserverWidget {
  const SProfileDefaultIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightProfileDefaultIcon()
        : const SimpleLightProfileDefaultIcon();
  }
}
