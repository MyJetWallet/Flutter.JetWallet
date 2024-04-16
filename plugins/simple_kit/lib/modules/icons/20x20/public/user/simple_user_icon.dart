import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/user/simple_light_user.dart';
import 'package:simple_kit/utils/enum.dart';

class SUserIcon extends StatelessObserverWidget {
  const SUserIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightUserMinusIcon(color: color)
        : SimpleLightUserMinusIcon(color: color);
  }
}
