import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/kyc/simple_light_passport_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPassportIcon extends StatelessObserverWidget {
  const SPassportIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightPassportIcon()
        : const SimpleLightPassportIcon();
  }
}
