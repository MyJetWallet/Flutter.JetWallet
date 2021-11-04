import 'package:flutter/material.dart';

import '../../base/simple_base_svg_102x56.dart';

class SimpleLightNumericKeyboardFaceIdIcon extends StatelessWidget {
  const SimpleLightNumericKeyboardFaceIdIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg102X56(
      assetName:
          'assets/icons/light/102x56/numeric_keyboard_face_id/numeric_keyboard_face_id.svg',
      color: color,
    );
  }
}
