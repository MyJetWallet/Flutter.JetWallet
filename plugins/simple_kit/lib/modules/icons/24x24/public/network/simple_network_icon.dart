import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/network/simple_network_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SNetworkIcon extends StatelessObserverWidget {
  const SNetworkIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightNetworkIcon(color: color)
        : SimpleLightNetworkIcon(color: color);
  }
}
