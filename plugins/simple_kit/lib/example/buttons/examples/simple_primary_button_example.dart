import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../shared.dart';

class SimplePrimaryButtonExample extends StatelessWidget {
  const SimplePrimaryButtonExample({Key? key}) : super(key: key);

  static const routeName = '/simple_primary_button_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ThemeSwitch(),
              const SpaceH20(),
              SPrimaryButton1(
                active: true,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              SPrimaryButton2(
                active: true,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              SPrimaryButton1(
                active: false,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              SPrimaryButton2(
                active: false,
                name: 'Primary',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
