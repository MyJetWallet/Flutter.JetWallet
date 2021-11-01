import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../../../shared.dart';
import 'simple_numeric_keyboard_pin_guides.dart';

class SimpleNumericKeyboardPinExample extends StatelessWidget {
  const SimpleNumericKeyboardPinExample({Key? key}) : super(key: key);

  static const routeName = '/simple_numeric_keyboard_pin_example';

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Column(
        children: [
          const Spacer(),
          const NavigationButton(
            buttonName: 'Guides',
            routeName: SimpleNumericKeyboardPinGuides.routeName,
          ),
          const Spacer(),
          SNumericKeyboardPin(
            onKeyPressed: (key) {
              showSnackBar(context, key);
            },
          ),
        ],
      ),
    );
  }
}
