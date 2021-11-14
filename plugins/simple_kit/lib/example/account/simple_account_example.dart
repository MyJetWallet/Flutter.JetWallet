import 'package:flutter/material.dart';
import 'package:simple_kit/example/account/headers/simple_account_headers_example.dart';

import '../shared.dart';
import 'buttons/simple_account_buttons_example.dart';

class SimpleAccountExample extends StatelessWidget {
  const SimpleAccountExample({Key? key}) : super(key: key);
  static const routeName = '/simple_account_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Buttons',
              routeName: SimpleAccountButtonsExample.routeName,
            ),

            NavigationButton(
              buttonName: 'Headers',
              routeName: SimpleAccountHeadersExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}