import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/log_out/simple_log_out_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SLogOutIcon extends StatelessObserverWidget {
  const SLogOutIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightLogOutIcon() : const SimpleLightLogOutIcon();
  }
}
