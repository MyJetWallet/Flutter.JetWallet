import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';

import '../../light/phone_call/simple_light_phone_call_icon.dart';

class SPhoneCallIcon extends StatelessObserverWidget {
  const SPhoneCallIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightPhoneCallIcon(color: color)
        : SimpleLightPhoneCallIcon(color: color);
  }
}
