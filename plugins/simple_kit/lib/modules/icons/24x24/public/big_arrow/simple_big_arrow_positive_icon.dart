import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/big_arrow/simple_light_big_arrow_positive.dart';
import 'package:simple_kit/utils/enum.dart';

class SBigArrowPositiveIcon extends StatelessObserverWidget {
  const SBigArrowPositiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightBigArrowPositiveIcon()
        : const SimpleLightBigArrowPositiveIcon();
  }
}
