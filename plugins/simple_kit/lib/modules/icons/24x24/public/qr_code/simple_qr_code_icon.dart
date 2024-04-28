import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/qr_code/simple_light_qr_code_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SQrCodeIcon extends StatelessObserverWidget {
  const SQrCodeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightQrCodeIcon()
        : const SimpleLightQrCodeIcon();
  }
}
