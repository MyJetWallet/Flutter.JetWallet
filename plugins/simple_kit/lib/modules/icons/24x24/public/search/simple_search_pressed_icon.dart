import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/search/simple_light_search_pressed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSearchPressedIcon extends StatelessObserverWidget {
  const SSearchPressedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightSearchPressedIcon()
        : const SimpleLightSearchPressedIcon();
  }
}
