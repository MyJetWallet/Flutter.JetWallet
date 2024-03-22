import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/deposit_in_progress/simple_light_deposit_in_progress_total_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SDepositTotalIcon extends StatelessObserverWidget {
  const SDepositTotalIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightDepositInProgressTotalIcon()
        : const SimpleLightDepositInProgressTotalIcon();
  }
}
