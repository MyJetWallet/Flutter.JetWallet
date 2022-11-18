import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/blue_right_arrow/simple_light_blue_right_arrow_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SBlueRightArrowIcon extends StatelessObserverWidget {
  const SBlueRightArrowIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightBlueRightArrowIcon()
        : const SimpleLightBlueRightArrowIcon();
  }
}
