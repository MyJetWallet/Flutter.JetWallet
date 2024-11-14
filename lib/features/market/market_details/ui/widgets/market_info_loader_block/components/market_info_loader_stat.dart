import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class MarketInfoLoaderStat extends StatelessWidget {
  const MarketInfoLoaderStat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SSkeletonLoader(
              height: 10,
              width: 61,
            ),
            SpaceH1(),
            SSkeletonLoader(
              height: 16,
              width: 88,
            ),
          ],
        ),
        SpaceH14(),
        SDivider(),
        SpaceH23(),
      ],
    );
  }
}
