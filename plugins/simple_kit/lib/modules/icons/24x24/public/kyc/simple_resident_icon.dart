import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/kyc/simple_light_resident_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SResidentIcon extends StatelessObserverWidget {
  const SResidentIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightResidentIcon()
        : const SimpleLightResidentIcon();
  }
}
