import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

class SimpleMarketHeaderTitle extends StatelessWidget {
  const SimpleMarketHeaderTitle({
    Key? key,
    required this.title,
    required this.onSearchButtonTap,
  }) : super(key: key);

  final String title;
  final Function() onSearchButtonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Baseline(
          baseline: 24.0,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            title,
            style: sTextH2Style,
          ),
        ),
        const Spacer(),
        Baseline(
          baseline: 24.0,
          baselineType: TextBaseline.alphabetic,
          child: SIconButton(
            onTap: onSearchButtonTap,
            defaultIcon: const SSearchIcon(),
            pressedIcon: const SSearchPressedIcon(),
          ),
        ),
      ],
    );
  }
}
