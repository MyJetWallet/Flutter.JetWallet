import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/light/stars/simple_light_stars.dart';
import 'package:simple_kit/utils/enum.dart';

class SStarsIcon extends StatelessObserverWidget {
  const SStarsIcon({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightStarsIcon(
            width: width,
            height: height,
          )
        : SimpleLightStarsIcon(
            width: width,
            height: height,
          );
  }
}
