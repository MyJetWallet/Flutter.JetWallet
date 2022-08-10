import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightGifReferralIcon extends StatelessWidget {
  const SimpleLightGifReferralIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/gift_referral/gift_referral.svg',
      color: color,
    );
  }
}
