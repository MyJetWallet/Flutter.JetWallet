import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/24x24/base/simple_base_svg_24x24.dart';

class SimpleLightNumericKeyboardFingerprintIcon extends StatelessWidget {
  const SimpleLightNumericKeyboardFingerprintIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/102x56/numeric_keyboard_fingerprint/numeric_keyboard_fingerprint.svg',
      color: color,
    );
  }
}