import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/deposit_in_progress/simple_light_deposit_in_progress_earn_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SDepositEarnIcon extends StatelessObserverWidget {
  const SDepositEarnIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightDepositInProgressEarnIcon()
        : const SimpleLightDepositInProgressEarnIcon();
  }
}
