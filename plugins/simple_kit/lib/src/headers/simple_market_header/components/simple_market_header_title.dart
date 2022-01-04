import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

class SimpleMarketHeaderTitle extends StatelessWidget {
  const SimpleMarketHeaderTitle({
    Key? key,
    this.onSearchButtonTap,
    required this.title,
  }) : super(key: key);

  final void Function()? onSearchButtonTap;
  final String title;

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
        if (onSearchButtonTap != null)
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
