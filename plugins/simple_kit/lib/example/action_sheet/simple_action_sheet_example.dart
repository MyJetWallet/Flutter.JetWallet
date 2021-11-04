import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_action_sheet_item_example.dart';
import 'examples/simple_common_action_sheet_example.dart';
import 'examples/simple_fiat_sheet_item_example.dart';
import 'examples/simple_menu_action_sheet_example.dart';

class SimpleActionSheetExample extends StatelessWidget {
  const SimpleActionSheetExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_sheet_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Common Action Sheet',
              routeName: SimpleCommonActionSheetExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Menu Action Sheet',
              routeName: SimpleMenuActionSheetExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Action Sheet Item',
              routeName: SimpleActionSheetItemExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Fiat Sheet Item',
              routeName: SimpleFiatSheetItemExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
