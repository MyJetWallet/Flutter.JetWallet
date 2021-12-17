import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleActionConfrimDescriptionExample extends StatelessWidget {
  const SimpleActionConfrimDescriptionExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_confirm_description_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const SActionConfirmDescription(
                    text: 'Final price will be recalculated based on the '
                        'market price at the very moment we get your '
                        'payment confirmation.',
                  ),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    color: Colors.red.withOpacity(0.2),
                    child: const Text('40px'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
