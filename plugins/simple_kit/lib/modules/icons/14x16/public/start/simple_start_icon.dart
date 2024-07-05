import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/14x16/light/start/simple_light_start_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SStartIcon extends StatelessObserverWidget {
  const SStartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightStartIcon() : const SimpleLightStartIcon();
  }
}
