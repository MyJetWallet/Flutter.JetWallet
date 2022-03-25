import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimplePaymentSelectDefaultExample extends StatelessWidget {
  const SimplePaymentSelectDefaultExample({Key? key}) : super(key: key);

  static const routeName = '/simple_payment_select_default_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SPaymentSelectDefault(
                  widgetSize: SWidgetSize.medium,
                  icon: const SActionBuyIcon(),
                  name: 'Choose payment method',
                  onTap: () {},
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceW24(),
                    Container(
                      width: 20.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    const Spacer(),
                    Container(
                      width: 20.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    const SpaceW24(),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 32.0,
                  color: Colors.blue.withOpacity(0.3),
                  child: const Text(
                    '32px',
                    textAlign: TextAlign.end,
                  ),
                ),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  color: Colors.green.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      SpaceH32(),
                      Text(
                        '50px',
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SpaceH20(),
            SPaymentSelectDefault(
              widgetSize: SWidgetSize.medium,
              icon: const SActionBuyIcon(),
              name: 'Choose payment method',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
