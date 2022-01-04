import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

class SimpleMarketHeaderTitle extends StatelessWidget {
  const SimpleMarketHeaderTitle({
    Key? key,
    this.onSearchButtonTap,
    required this.title,
  }) : super(key: key);

  // TODO for some reason when parameter is not provided
  // it's [Closure: () => Null] and isn't [null],
  // so, if-check on the null doesn't work. Investiagte!
  // Couldn't reproduce the issue on other screens
  final Function()? onSearchButtonTap;
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
        // TODO uncomment when search feature will be ready
        // const Spacer(),
        // Baseline(
        //   baseline: 24.0,
        //   baselineType: TextBaseline.alphabetic,
        //   child: SIconButton(
        //     onTap: onSearchButtonTap,
        //     defaultIcon: const SSearchIcon(),
        //     pressedIcon: const SSearchPressedIcon(),
        //   ),
        // ),
      ],
    );
  }
}
