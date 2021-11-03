import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleMenuActionSheetExample extends StatelessWidget {
  const SimpleMenuActionSheetExample({Key? key}) : super(key: key);

  static const routeName = '/simple_menu_action_sheet_example';

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
