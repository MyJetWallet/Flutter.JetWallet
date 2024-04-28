import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/index_history/simple_light_index_history_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SIndexHistoryIcon extends StatelessObserverWidget {
  const SIndexHistoryIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightIndexHistoryIcon()
        : const SimpleLightIndexHistoryIcon();
  }
}
