import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_password_requirement_example.dart';
import 'examples/simple_privacy_policy_example.dart';

class SimpleAgreementsExample extends StatelessWidget {
  const SimpleAgreementsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_agreements_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Privacy Policy',
              routeName: SimplePrivacyPolicyExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Requirements',
              routeName: SimplePasswordRequirementExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
