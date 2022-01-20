import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimplePaymentSelectContactExample extends StatelessWidget {
  const SimplePaymentSelectContactExample({Key? key}) : super(key: key);

  static const routeName = '/simple_payment_select_contact_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                const SPaymentSelectContact(
                  name: 'Dimas from Moscow',
                  phone: '+3803919219221',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceW24(),
                    const SpaceW20(),
                    Column(
                      children: [
                        const SpaceH24(),
                        Stack(
                          children: [
                            const SizedBox(
                              width: 40.0,
                              height: 40.0,
                            ),
                            Container(
                              width: 40.0,
                              height: 26.0,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ],
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
                      height: 24.0,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Text(
                        '24px',
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 18.0,
                      color: Colors.red.withOpacity(0.3),
                      child: const Text(
                        '42px',
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: double.infinity,
                      color: Colors.green.withOpacity(0.3),
                      child: const Text(
                        '20px',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SpaceH20(),
            const SPaymentSelectContact(
              name: 'Dimas from Moscow',
              phone: '+3803919219221',
            ),
          ],
        ),
      ),
    );
  }
}
