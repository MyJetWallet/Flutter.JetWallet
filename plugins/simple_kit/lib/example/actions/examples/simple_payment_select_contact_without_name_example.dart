import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimplePaymentSelectContactWithoutNameExample extends StatelessWidget {
  const SimplePaymentSelectContactWithoutNameExample({Key? key})
      : super(key: key);

  static const routeName =
      '/simple_payment_select_contact_without_name_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                const SPaymentSelectContactWithoutName(
                  widgetSize: SWidgetSize.medium,
                  phone: '+3803919219221',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceW24(),
                    const SpaceW20(),
                    Column(
                      children: [
                        const SpaceH32(),
                        Container(
                          width: 24.0,
                          height: 24.0,
                          color: Colors.red.withOpacity(0.3),
                        ),
                      ],
                    ),
                    Container(
                      width: 10.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('10px'),
                    ),
                  ],
                ),
                Column(
                  children: [
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
                      width: double.infinity,
                      height: 18.0,
                      color: Colors.red.withOpacity(0.3),
                      child: const Text(
                        '50px',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SpaceH20(),
            const SPaymentSelectContactWithoutName(
              widgetSize: SWidgetSize.medium,
              phone: '+3803919219221',
            ),
          ],
        ),
      ),
    );
  }
}
