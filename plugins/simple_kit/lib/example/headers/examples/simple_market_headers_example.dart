import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../../src/headers/simple_market_header/simple_market_header.dart';
import '../../../src/headers/simple_market_header/simple_market_header_closed.dart';
import '../../shared.dart';

class SimpleMarketHeadersExample extends StatelessWidget {
  const SimpleMarketHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_market_headers_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SPaddingH24(
            child: SMarketHeader(
              title: 'Title',
              percent: 1.73,
              isPositive: true,
              subtitle: 'Subtitle',
              onSearchButtonTap: () => showSnackBar(context),
            ),
          ),
          SMarketHeaderClosed(
            title: 'Title',
            onSearchButtonTap: () => showSnackBar(context),
          ),
        ],
      ),
    );
  }
}
