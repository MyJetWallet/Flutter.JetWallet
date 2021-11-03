import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleMenuActionSheetExample extends StatelessWidget {
  const SimpleMenuActionSheetExample({Key? key}) : super(key: key);

  static const routeName = '/simple_menu_action_sheet_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                sShowMenuActionSheet(
                  context: context,
                  onBuy: () {},
                  onSell: () {},
                  onConvert: () {},
                  onDeposit: () {},
                  onWithdraw: () {},
                  onSend: () {},
                  onReceive: () {},
                );
              },
              child: const Text(
                'Show Action Sheet',
              ),
            )
          ],
        ),
      ),
    );
  }
}
