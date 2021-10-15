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
          children: const [
            ThemeSwitch(),
            SpaceH20(),
            STextH0(
              text: 'H0 - Simple',
            ),
            STextH1(
              text: 'H1 - Simple',
            ),
            STextH2(
              text: 'H2 - Simple',
            ),
            STextH3(
              text: 'H3 - Simple',
            ),
            STextH4(
              text: 'H4 - Simple',
            ),
            STextH5(
              text: 'H5 - Simple',
            ),
            SpaceH20(),
            SSubtitleText1(
              text: 'Subtitle 1 - Simple',
            ),
            SSubtitleText2(
              text: 'Subtitle 2 - Simple',
            ),
            SSubtitleText3(
              text: 'Subtitle 3 - Simple',
            ),
            SpaceH20(),
            SBodyText1(
              text: 'Body 1 - Simple',
            ),
            SBodyText2(
              text: 'Body 2 - Simple',
            ),
            SpaceH20(),
            SButtonText(
              text: 'Button - Simple',
            ),
            SpaceH20(),
            SCaptionText(
              text: 'Caption - Simple',
            ),
            SOverlineText(
              text: 'OVERLINE - SIMPLE',
            )
          ],
        ),
      ),
    );
  }
}
