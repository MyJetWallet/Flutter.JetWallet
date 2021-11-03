import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleAssetItemExample extends StatelessWidget {
  const SimpleAssetItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_asset_item_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
