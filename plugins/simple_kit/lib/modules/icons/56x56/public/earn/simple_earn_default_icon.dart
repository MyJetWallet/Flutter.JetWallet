import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/earn/simple_light_earn_default_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SEarnDefaultIcon extends StatelessObserverWidget {
  const SEarnDefaultIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightEarnDefaultIcon() : const SimpleLightEarnDefaultIcon();
  }
}
