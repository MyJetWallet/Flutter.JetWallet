import 'package:flutter/material.dart';
import '../../../simple_kit.dart';

class SimpleAccountButtonsExample extends StatelessWidget {
  const SimpleAccountButtonsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_account_buttons_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SimpleAccountCategoryButton(
              icon: SSecurityIcon(),
              title: 'Button',
              isSDivider: true,
            ),


          ],
        ),
      ),
    );
  }
}