import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../../src/headers/simple_big_header.dart';
import '../../shared.dart';

class SimpleBigHeadersExample extends StatelessWidget {
  const SimpleBigHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_big_headers_example';

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Column(
        children: [
          SBigHeader(
            title: 'Title',
            onBackButtonTap: () => showSnackBar(context),
          ),
          SBigHeader(
            title: 'Title',
            showSearchButton: true,
            onBackButtonTap: () => showSnackBar(context),
            onSearchButtonTap: () => showSnackBar(context),
          ),
          SBigHeader(
            title: 'Title',
            linkText: 'Link',
            showLink: true,
            onLinkTap: () => showSnackBar(context),
            onBackButtonTap: () => showSnackBar(context),
            onSearchButtonTap: () => showSnackBar(context),
          ),
        ],
      ),
    );
  }
}
