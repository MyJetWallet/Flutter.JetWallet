import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../shared.dart';

class SimpleTextsExample extends StatelessWidget {
  const SimpleTextsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_texts_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ThemeSwitch(),
            const SpaceH20(),
            Text(
              'H0 - Simple',
              style: sTextH0Style,
            ),
            Text(
              'H1 - Simple',
              style: sTextH1Style,
            ),
            Text(
              'H2 - Simple',
              style: sTextH2Style,
            ),
            Text(
              'H3 - Simple',
              style: sTextH3Style,
            ),
            Text(
              'H4 - Simple',
              style: sTextH4Style,
            ),
            Text(
              'H5 - Simple',
              style: sTextH5Style,
            ),
            const SpaceH20(),
            Text(
              'Subtitle 1 - Simple',
              style: sSubtitle1Style,
            ),
            Text(
              'Subtitle 2 - Simple',
              style: sSubtitle2Style,
            ),
            Text(
              'Subtitle 3 - Simple',
              style: sSubtitle3Style,
            ),
            const SpaceH20(),
            Text(
              'Body 1 - Simple',
              style: sBodyText1Style,
            ),
            Text(
              'Body 2 - Simple',
              style: sBodyText2Style,
            ),
            const SpaceH20(),
            Text(
              'Button - Simple',
              style: sButtonTextStyle,
            ),
            const SpaceH20(),
            Text(
              'Caption - Simple',
              style: sCaptionTextStyle,
            ),
            Text(
              'OVERLINE - SIMPLE',
              style: sOverlineTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
