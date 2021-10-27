import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../../src/headers/simple_small_header.dart';
import '../../shared.dart';

class SimpleSmallHeadersExample extends StatelessWidget {
  const SimpleSmallHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_small_headers_example';

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Column(
        children: [
          const SSmallHeader(
            title: 'Title',
            showBackButton: false,
          ),
          SSmallHeader(
            title: 'Title',
            onBackButtonTap: () => showSnackBar(context),
          ),
          SSmallHeader(
            title: 'Title',
            showBackButton: false,
            showStarButton: true,
            onBackButtonTap: () => showSnackBar(context),
            onStarButtonTap: () => showSnackBar(context),
          ),
          SSmallHeader(
            title: 'Title',
            showStarButton: true,
            onBackButtonTap: () => showSnackBar(context),
            onStarButtonTap: () => showSnackBar(context),
          ),
        ],
      ),
    );
  }
}
