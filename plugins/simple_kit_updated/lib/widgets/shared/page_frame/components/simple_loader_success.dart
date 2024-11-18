import 'package:flutter/material.dart';

import 'package:simple_kit_updated/simple_kit_updated.dart';

class SimpleLoaderSuccess extends StatelessWidget {
  const SimpleLoaderSuccess({
    super.key,
    this.loadingText,
  });

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 97.0,
      right: 98.0,
      top: 320.0,
      child: Container(
        width: 180.0,
        height: 90.0,
        decoration: BoxDecoration(
          color: SColorsLight().white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.svg.small.checkCircle.simpleSvg(
              width: 24,
              height: 24,
            ),
            Baseline(
              baseline: 20.6,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                '${loadingText ?? "Done"}!',
                style: STStyles.body2Medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
