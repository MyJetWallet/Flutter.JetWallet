import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/service_providers.dart';

class IndexOverviewBlock extends HookWidget {
  const IndexOverviewBlock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

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
                intl.indexOverview,
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
                intl.type,
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
                intl.equalWeightedIndex,
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
                intl.rebalancing,
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
                intl.quarterlyRebalancing,
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
