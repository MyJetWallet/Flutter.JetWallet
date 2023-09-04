import 'package:flutter/material.dart';
import '../../base/simple_base_svg_18x18.dart';

class SimpleLightPaidInterestRateIcon extends StatelessWidget {
  const SimpleLightPaidInterestRateIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg18x18(
      assetName:
          'assets/icons/light/18x18/paid_interest_rate/paid_interest_rate.svg',
      color: color,
    );
  }
}
