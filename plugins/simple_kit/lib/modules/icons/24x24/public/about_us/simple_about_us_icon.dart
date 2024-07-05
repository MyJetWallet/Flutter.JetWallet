import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/about_us/simple_light_about_us_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAboutUsIcon extends StatelessObserverWidget {
  const SAboutUsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightAboutUsIcon() : const SimpleLightAboutUsIcon();
  }
}
