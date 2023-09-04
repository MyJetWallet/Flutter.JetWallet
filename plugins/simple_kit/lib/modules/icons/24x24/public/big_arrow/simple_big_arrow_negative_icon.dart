import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/big_arrow/simple_light_big_arrow_negative.dart';
import 'package:simple_kit/utils/enum.dart';

class SBigArrowNegativeIcon extends StatelessObserverWidget {
  const SBigArrowNegativeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightBigArrowNegativeIcon()
        : const SimpleLightBigArrowNegativeIcon();
  }
}
