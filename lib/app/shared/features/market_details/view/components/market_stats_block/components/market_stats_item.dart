import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketStatsItem extends HookWidget {
  const MarketStatsItem({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 44,
              child: Baseline(
                baseline: 41,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  name,
                  style: sBodyText2Style.copyWith(color: colors.grey1),
                ),
              ),
            ),
            SizedBox(
              height: 24,
              child: Baseline(
                baseline: 20,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  value,
                  style: sBodyText1Style,
                ),
              ),
            ),
          ],
        ),
        const SpaceH12(),
        const SDivider(),
      ],
    );
  }
}
