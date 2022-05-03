import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/market_info_loader_stat.dart';

class MarketInfoLoaderBlock extends HookWidget {
  const MarketInfoLoaderBlock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH20(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 56,
                child: Baseline(
                  baseline: 35,
                  baselineType: TextBaseline.alphabetic,
                  child: SSkeletonTextLoader(
                    height: 16,
                    width: 133,
                  ),
                ),
              ),
              const SpaceH6(),
              Table(
                children: const [
                  TableRow(
                    children: [
                      TableCell(
                        child: MarketInfoLoaderStat(),
                      ),
                      TableCell(
                        child: MarketInfoLoaderStat(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: MarketInfoLoaderStat(),
                      ),
                      TableCell(
                        child: MarketInfoLoaderStat(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
