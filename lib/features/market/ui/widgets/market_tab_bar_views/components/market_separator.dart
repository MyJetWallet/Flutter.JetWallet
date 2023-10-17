import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketSeparator extends StatelessObserverWidget {
  const MarketSeparator({
    super.key,
    required this.text,
    this.isNeedDivider = true,
  });

  final String text;
  final bool isNeedDivider;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      height: 21,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 24,
            ),
            child: Baseline(
              baseline: 11,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                text,
                style: sCaptionTextStyle.copyWith(
                  color: colors.grey3,
                ),
              ),
            ),
          ),
          const SpaceW10(),
          if (isNeedDivider)
            Expanded(
              child: SDivider(
                color: colors.grey3,
              ),
            ),
        ],
      ),
    );
  }
}
