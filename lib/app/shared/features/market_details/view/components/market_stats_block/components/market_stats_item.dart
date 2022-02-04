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
