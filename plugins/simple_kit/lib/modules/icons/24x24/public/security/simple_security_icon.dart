import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/security/simple_light_security_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSecurityIcon extends StatelessObserverWidget {
  const SSecurityIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightSecurityIcon(color: color)
        : SimpleLightSecurityIcon(color: color);
  }
}
