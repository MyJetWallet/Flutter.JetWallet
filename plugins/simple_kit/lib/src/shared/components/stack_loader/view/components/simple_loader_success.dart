import 'package:flutter/material.dart';

import '../../../../../../simple_kit.dart';
import '../../../../../colors/view/simple_colors_light.dart';

class SimpleLoaderSuccess extends StatelessWidget {
  const SimpleLoaderSuccess({Key? key}) : super(key: key);

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
            const SCompleteIcon(),
            Baseline(
              baseline: 20.6,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                'Done!',
                style: sBodyText2Style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
