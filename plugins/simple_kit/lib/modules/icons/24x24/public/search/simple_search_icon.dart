import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/search/simple_light_search_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSearchIcon extends StatelessObserverWidget {
  const SSearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightSearchIcon() : const SimpleLightSearchIcon();
  }
}
