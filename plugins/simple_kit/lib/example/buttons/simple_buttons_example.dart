import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_link_button_example.dart';
import 'examples/simple_primary_button_example.dart';
import 'examples/simple_secondary_button_example.dart';
import 'examples/simple_text_button_example.dart';

class SimpleButtonsExample extends StatelessWidget {
  const SimpleButtonsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_buttons_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Primary buttons',
              routeName: SimplePrimaryButtonExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Secondary buttons',
              routeName: SimpleSecondaryButtonExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Text buttons',
              routeName: SimpleTextButtonExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Link buttons',
              routeName: SimpleLinkButtonExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
