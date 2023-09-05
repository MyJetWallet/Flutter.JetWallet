import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/change_pin/simple_light_change_pin_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SChangePinIcon extends StatelessObserverWidget {
  const SChangePinIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightChangePinIcon()
        : const SimpleLightChangePinIcon();
  }
}
