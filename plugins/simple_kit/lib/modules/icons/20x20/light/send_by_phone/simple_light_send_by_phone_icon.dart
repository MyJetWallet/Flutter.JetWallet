import 'package:flutter/material.dart';
import '../../base/simple_base_svg_20x20.dart';

class SimpleLightSendByPhoneIcon extends StatelessWidget {
  const SimpleLightSendByPhoneIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/send_by_phone/send_by_phone.svg',
      color: color,
    );
  }
}
