import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/phone/simple_light_phone_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPhoneIcon extends StatelessObserverWidget {
  const SPhoneIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightPhoneIcon(color: color)
        : SimpleLightPhoneIcon(color: color);
  }
}
