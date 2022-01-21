import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class IndexOverviewBlock extends HookWidget {
  const IndexOverviewBlock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Index overview',
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
                'Type',
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
                'Equal-Weighted Index',
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
                'Rebalancing',
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
                'Quarterly rebalancing to equal-weighted',
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
