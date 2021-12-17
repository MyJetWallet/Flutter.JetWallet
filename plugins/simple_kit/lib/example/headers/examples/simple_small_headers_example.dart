import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../shared.dart';

class SimpleSmallHeadersExample extends StatelessWidget {
  const SimpleSmallHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_small_headers_example';

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
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
          const SpaceH20(),
          Stack(
            children: [
              Container(
                height: 120.0,
                color: Colors.grey.withOpacity(0.3),
              ),
              Center(
                child: Container(
                  width: 100,
                  height: 84.0,
                  color: Colors.green.withOpacity(0.3),
                  child: const Center(
                    child: Text('84px'),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 64.0,
                    color: Colors.blue.withOpacity(0.2),
                    child: const Center(
                      child: Text('64px'),
                    ),
                  ),
                  Container(
                    height: 24.0,
                    color: Colors.red.withOpacity(0.3),
                    child: Row(
                      children: const [
                        SpaceW40(),
                        Center(
                          child: Text('24px'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 32.0,
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Text('32px'),
                    ),
                  ),
                ],
              ),
              SSmallHeader(
                title: 'Title',
                showStarButton: true,
                onBackButtonTap: () => showSnackBar(context),
                onStarButtonTap: () => showSnackBar(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
