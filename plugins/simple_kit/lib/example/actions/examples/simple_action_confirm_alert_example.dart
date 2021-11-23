import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleActionConfrimAlertExample extends StatelessWidget {
  const SimpleActionConfrimAlertExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_confirm_alert_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SActionConfirmAlert(),
            ],
          ),
        ),
      ),
    );
  }
}
