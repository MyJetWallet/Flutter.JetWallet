import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_icons_16x16_example.dart';
import 'examples/simple_icons_20x20_example.dart';
import 'examples/simple_icons_24x24_example.dart';
import 'examples/simple_icons_36x36_example.dart';

class SimpleIconsExample extends StatelessWidget {
  const SimpleIconsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: '16x16',
              routeName: SimpleIcons16X16Example.routeName,
            ),
            NavigationButton(
              buttonName: '20x20',
              routeName: SimpleIcons20X20Example.routeName,
            ),
            NavigationButton(
              buttonName: '24x24',
              routeName: SimpleIcons24X24Example.routeName,
            ),
            NavigationButton(
              buttonName: '36x36',
              routeName: SimpleIcons36X36Example.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
