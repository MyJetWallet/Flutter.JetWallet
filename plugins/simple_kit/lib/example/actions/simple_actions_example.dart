import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_action_confirm_alert_example.dart';
import 'examples/simple_action_confirm_description_example.dart';
import 'examples/simple_action_confirm_skeleton_loader_example.dart';
import 'examples/simple_action_confirm_text_example.dart';
import 'examples/simple_action_price_field_example.dart';
import 'examples/simple_payment_select_asset_example.dart';
import 'examples/simple_payment_select_contact_example.dart';
import 'examples/simple_payment_select_contact_without_name_example.dart';
import 'examples/simple_payment_select_default_example.dart';
import 'examples/simple_payment_select_fiat_example.dart';

class SimpleActionsExample extends StatelessWidget {
  const SimpleActionsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_actions_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: 'Payment Select Contact',
              routeName: SimplePaymentSelectContactExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Payment Select Contact Without Name',
              routeName: SimplePaymentSelectContactWithoutNameExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Payment Select Default',
              routeName: SimplePaymentSelectDefaultExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Payment Select Asset',
              routeName: SimplePaymentSelectAssetExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Payment Select Fiat',
              routeName: SimplePaymentSelectFiatExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Action Price Field',
              routeName: SimpleActionPriceFieldExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Action Confirm Text',
              routeName: SimpleActionConfirmTextExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Action Confirm Description',
              routeName: SimpleActionConfrimDescriptionExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Skeleton Loader',
              routeName: SimpleActionConfrimSkeletonLoaderExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Action Confirm Alert',
              routeName: SimpleActionConfrimAlertExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
