import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../../src/action_sheet/components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../src/action_sheet/components/simple_bottom_sheet_header.dart';

class SimpleCommonActionSheetExample extends StatelessWidget {
  const SimpleCommonActionSheetExample({Key? key}) : super(key: key);

  static const routeName = '/simple_common_action_sheet_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                showBasicBottomSheet(
                  context: context,
                  pinned: const SBottomSheetHeader(
                    name: 'Deposit With',
                  ),
                  children: [
                    SFiatSheetItem(
                      icon: const SActionBuyIcon(),
                      name: 'Fiat Currency',
                      amount: '\$0.00',
                      onTap: () {},
                    ),
                    SAssetSheetItem(
                      icon: const SActionBuyIcon(),
                      name: 'Asset Name',
                      amount: '\$0.00',
                      description: 'Asset balance',
                      onTap: () {},
                    ),
                    const SpaceH20(),
                  ],
                );
              },
              child: const Text('Show Common Action Sheet'),
            )
          ],
        ),
      ),
    );
  }
}
