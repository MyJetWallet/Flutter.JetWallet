import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/history_completed/simple_light_history_completed_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SHistoryCompletedIcon extends StatelessObserverWidget {
  const SHistoryCompletedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightHistoryCompletedIcon()
        : const SimpleLightHistoryCompletedIcon();
  }
}
