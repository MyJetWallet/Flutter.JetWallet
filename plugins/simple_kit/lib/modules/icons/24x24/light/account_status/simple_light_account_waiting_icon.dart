import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightAccountWaitingIcon extends StatelessWidget {
  const SimpleLightAccountWaitingIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/account_status/waiting.svg',
      color: color,
    );
  }
}
