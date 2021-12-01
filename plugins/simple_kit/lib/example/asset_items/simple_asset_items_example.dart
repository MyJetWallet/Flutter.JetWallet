import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_action_item_example.dart';
import 'examples/simple_asset_item_example.dart';
import 'examples/simple_fiat_item_example.dart';
import 'examples/simple_market_item_example.dart';
import 'examples/simple_wallet_item_example.dart';

class SimpleAssetItemsExample extends StatelessWidget {
  const SimpleAssetItemsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_asset_items_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Asset Item',
              routeName: SimpleAssetItemExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Action Item',
              routeName: SimpleActionItemExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Fiat Item',
              routeName: SimpleFiatItemExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Market Item',
              routeName: SimpleMarketItemExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Wallet Item',
              routeName: SimpleWalletItemExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
