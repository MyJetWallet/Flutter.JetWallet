import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/36x36/light/fingerprint/simple_light_fingerprint_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SFingerprintIcon extends StatelessObserverWidget {
  const SFingerprintIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightFingerprintIcon() : const SimpleLightFingerprintIcon();
  }
}
