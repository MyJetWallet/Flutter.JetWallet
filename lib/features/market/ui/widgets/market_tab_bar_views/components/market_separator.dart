import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
    final colors = SColorsLight();

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
                style: STStyles.captionMedium.copyWith(
                  color: colors.gray6,
                ),
              ),
            ),
          ),
          const SpaceW10(),
          if (isNeedDivider)
            const Expanded(
              child: SDivider(),
            ),
        ],
      ),
    );
  }
}
