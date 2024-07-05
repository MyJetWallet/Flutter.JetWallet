import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/16x16/light/fee_alert/simple_light_fee_alert_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SFeeAlertIcon extends StatelessObserverWidget {
  const SFeeAlertIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightFeeAlertIcon() : const SimpleLightFeeAlertIcon();
  }
}
