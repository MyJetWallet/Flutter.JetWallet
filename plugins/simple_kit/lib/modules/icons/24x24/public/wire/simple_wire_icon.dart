import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/wire/simple_light_wire_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SWireIcon extends StatelessObserverWidget {
  const SWireIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightWireIcon()
        : const SimpleLightWireIcon();
  }
}
