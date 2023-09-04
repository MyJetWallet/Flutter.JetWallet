import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/recurring_buys/simple_light_recurring_buys_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SRecurringBuysIcon extends StatelessObserverWidget {
  const SRecurringBuysIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightRecurringBuysIcon()
        : const SimpleLightRecurringBuysIcon();
  }
}
