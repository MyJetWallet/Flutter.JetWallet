import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../shared.dart';

class SimpleBigHeadersExample extends StatelessWidget {
  const SimpleBigHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_big_headers_example';

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
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
          Stack(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.3),
                height: 180.0,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.blue.withOpacity(0.3),
                    height: 64.0,
                    child: const Center(
                      child: Text('64px'),
                    ),
                  ),
                  Container(
                    color: Colors.red.withOpacity(0.3),
                    height: 24.0,
                    child: const Center(
                      child: Text('24px'),
                    ),
                  ),
                  Container(
                    color: Colors.green.withOpacity(0.3),
                    height: 56.0,
                    child: const Center(
                      child: Text('56px'),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    height: 36.0,
                    width: 100,
                    child: const Center(
                      child: Text('36px'),
                    ),
                  ),
                ],
              ),
              SBigHeader(
                title: 'Title',
                linkText: 'Link',
                showLink: true,
                showSearchButton: true,
                onLinkTap: () => showSnackBar(context),
                onBackButtonTap: () => showSnackBar(context),
                onSearchButtonTap: () => showSnackBar(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
