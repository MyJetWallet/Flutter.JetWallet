import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/receive_by_phone/simple_light_receive_by_phone_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SReceiveByPhoneIcon extends StatelessObserverWidget {
  const SReceiveByPhoneIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightReceiveByPhoneIcon(color: color)
        : SimpleLightReceiveByPhoneIcon(color: color);
  }
}
