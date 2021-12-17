import 'package:flutter/material.dart';
import '../../../simple_kit.dart';

class SimpleAccountIndicatorsExample extends StatelessWidget {
  const SimpleAccountIndicatorsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_account_indicators_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SimpleAccountProtectionIndicator(
              indicatorColor: Colors.green,
            ),
            SpaceH20(),
            SimpleAccountProtectionIndicator(
              indicatorColor: Colors.yellow,
            ),
            SpaceH20(),
            SimpleAccountProtectionIndicator(
              indicatorColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
