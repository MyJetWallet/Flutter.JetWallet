import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';

import '../../light/purchase/simple_light_purchase_icon.dart';

class SPurchaseIcon extends StatelessObserverWidget {
  const SPurchaseIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightPurchaseIcon(color: color,)
        : SimpleLightPurchaseIcon(color: color,);
  }
}
