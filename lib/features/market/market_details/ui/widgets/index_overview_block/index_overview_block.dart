import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class IndexOverviewBlock extends StatelessWidget {
  const IndexOverviewBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: Baseline(
              baseline: 49,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.indexOverviewBlock_indexOverview,
                style: sTextH4Style,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: Baseline(
              baseline: 40,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.indexOverviewBlock_type,
                style: sBodyText2Style.copyWith(color: colors.grey1),
              ),
            ),
          ),
          SizedBox(
            height: 24,
            child: Baseline(
              baseline: 19,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.indexOverviewBlock_equalWeightedIndex,
                style: sBodyText1Style,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Baseline(
              baseline: 36,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.indexOverviewBlock_rebalancing,
                style: sBodyText2Style.copyWith(color: colors.grey1),
              ),
            ),
          ),
          SizedBox(
            height: 24,
            child: Baseline(
              baseline: 19,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.indexOverviewBlock_quarterlyRebalancing,
                style: sBodyText1Style,
              ),
            ),
          ),
          const SpaceH40(),
          const SDivider(),
        ],
      ),
    );
  }
}
