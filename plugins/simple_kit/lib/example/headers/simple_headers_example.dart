import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_big_headers_example.dart';
import 'examples/simple_market_headers_example.dart';
import 'examples/simple_small_headers_example.dart';

class SimpleHeadersExample extends StatelessWidget {
  const SimpleHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_headers_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Small Headers',
              routeName: SimpleSmallHeadersExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Big Headers',
              routeName: SimpleBigHeadersExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Market Headers',
              routeName: SimpleMarketHeadersExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
