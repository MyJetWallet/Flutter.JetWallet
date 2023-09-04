import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketStatsItem extends StatelessWidget {
  const MarketStatsItem({
    super.key,
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: sBodyText2Style.copyWith(color: colors.grey1),
            ),
            const SpaceH1(),
            Text(
              value,
              style: sBodyText1Style,
            ),
          ],
        ),
        const SpaceH14(),
        const SDivider(),
        const SpaceH23(),
      ],
    );
  }
}
