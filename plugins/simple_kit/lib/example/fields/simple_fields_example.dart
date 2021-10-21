import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_confirmation_code_field_example.dart';
import 'examples/simple_pin_code_field_example.dart';
import 'examples/simple_standard_field_example.dart';

class SimpleFieldsExample extends StatelessWidget {
  const SimpleFieldsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_fields_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Standard Field',
              routeName: SimpleStandardFieldExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Confirmation Code Field',
              routeName: SimpleConfirmationCodeFieldExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Pin Code Field',
              routeName: SimplePinCodeFieldExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
