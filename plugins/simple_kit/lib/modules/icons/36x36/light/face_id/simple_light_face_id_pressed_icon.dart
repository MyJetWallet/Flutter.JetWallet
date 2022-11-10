import 'package:flutter/material.dart';

import '../../base/simple_base_svg_36x36.dart';

class SimpleLightFaceIdPressedIcon extends StatelessWidget {
  const SimpleLightFaceIdPressedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg36X36(
      assetName: 'assets/icons/light/36x36/face_id/face_id_pressed.svg',
      color: color,
    );
  }
}
