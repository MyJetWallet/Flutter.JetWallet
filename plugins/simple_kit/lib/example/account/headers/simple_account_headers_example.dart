import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../../src/colors/view/simple_colors_light.dart';

class SimpleAccountHeadersExample extends StatelessWidget {
  const SimpleAccountHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_account_headers_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: SColorsLight().black,
                ),
              ),
              child: const SimpleAccountCategoryHeader(
                userEmail: 'email@smplt.net',
                userFirstName: 'FirstName',
                userLastName: 'LastName',
                showUserName: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
