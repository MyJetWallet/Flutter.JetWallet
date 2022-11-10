import 'package:flutter/material.dart';

import '../../base/simple_base_svg_40x22.dart';

class SimpleLightDeleteIcon extends StatelessWidget {
  const SimpleLightDeleteIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg40X22(
      assetName: 'assets/icons/light/40x22/delete/delete.svg',
      color: color,
    );
  }
}
