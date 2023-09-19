import 'package:flutter/material.dart';
import '../../base/simple_base_svg_20x20.dart';

class SimpleLightReceiveByPhoneIcon extends StatelessWidget {
  const SimpleLightReceiveByPhoneIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName:
          'assets/icons/light/20x20/receive_by_phone/receive_by_phone.svg',
      color: color,
    );
  }
}
