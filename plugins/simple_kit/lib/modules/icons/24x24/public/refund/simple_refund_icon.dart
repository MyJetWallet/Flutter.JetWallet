import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/refund/simple_light_refund_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SRefundIcon extends StatelessObserverWidget {
  const SRefundIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleLightRefundIcon(color: color) : SimpleLightRefundIcon(color: color);
  }
}
