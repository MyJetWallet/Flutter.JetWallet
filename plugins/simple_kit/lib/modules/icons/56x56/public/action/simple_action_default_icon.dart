import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/action/simple_light_action_default_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionDefaultIcon extends StatelessObserverWidget {
  const SActionDefaultIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightActionDefaultIcon()
        : const SimpleLightActionDefaultIcon();
  }
}
