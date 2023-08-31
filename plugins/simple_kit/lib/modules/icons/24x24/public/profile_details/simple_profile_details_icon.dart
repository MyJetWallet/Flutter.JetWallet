import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/profile_details/simple_light_profile_details_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SProfileDetailsIcon extends StatelessObserverWidget {
  const SProfileDetailsIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightProfileDetailsIcon(color: color)
        : SimpleLightProfileDetailsIcon(color: color);
  }
}
