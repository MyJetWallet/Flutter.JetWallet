import 'package:flutter/material.dart';

import '../../../../../../simple_kit.dart';
import '../../../../../colors/view/simple_colors_light.dart';

class LoaderContainer extends StatelessWidget {
  const LoaderContainer({
    Key? key,
    this.loadingText,
  }) : super(key: key);

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
            const LoaderSpinner(),
            Baseline(
              baseline: 20.6,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                '${loadingText ?? "Please wait"} ...',
                style: sBodyText2Style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
