import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/16x16/light/small_arrow/simple_light_small_arrow_positive_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSmallArrowPositiveIcon extends StatelessObserverWidget {
  const SSmallArrowPositiveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightSmallArrowPositiveIcon()
        : const SimpleLightSmallArrowPositiveIcon();
  }
}
