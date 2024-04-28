import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/16x16/light/small_arrow/simple_light_small_arrow_negative_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSmallArrowNegativeIcon extends StatelessObserverWidget {
  const SSmallArrowNegativeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightSmallArrowNegativeIcon()
        : const SimpleLightSmallArrowNegativeIcon();
  }
}
