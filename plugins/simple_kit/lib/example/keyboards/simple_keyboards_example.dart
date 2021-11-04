import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_numeric_keyboard_amount/simple_numeric_keyboard_amount_example.dart';
import 'examples/simple_numeric_keyboard_pin/simple_numeric_keyboard_pin_example.dart';

class SimpleKeyboardsExample extends StatelessWidget {
  const SimpleKeyboardsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_keyboards_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Numeric keyboard (AMOUNT)',
              routeName: SimpleNumericKeyboardAmountExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Numeric keyboard (PIN)',
              routeName: SimpleNumericKeyboardPinExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
