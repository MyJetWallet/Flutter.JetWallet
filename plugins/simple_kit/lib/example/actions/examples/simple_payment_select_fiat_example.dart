import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimplePaymentSelectFiatExample extends StatelessWidget {
  const SimplePaymentSelectFiatExample({Key? key}) : super(key: key);

  static const routeName = '/simple_payment_select_fiat_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SPaymentSelectFiat(
                  icon: const SActionBuyIcon(),
                  name: 'Fiat currency',
                  amount: '\$0.00',
                  onTap: () {},
                ),
                SPaddingH24(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20.0,
                        height: 88.0,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          const SpaceH30(),
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
                      Container(
                        width: 130.0,
                        height: 88.0,
                        color: Colors.red.withOpacity(0.2),
                        child: Column(
                          children: const [
                            Spacer(),
                            Text('130px'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 110.0,
                        height: 88.0,
                        color: Colors.red.withOpacity(0.2),
                        child: Column(
                          children: const [
                            Spacer(),
                            Text('110px'),
                          ],
                        ),
                      ),
                      Container(
                        width: 20.0,
                        height: 88.0,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 30.0,
                  color: Colors.blue.withOpacity(0.3),
                  child: const Text(
                    '30px',
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 48.0,
                  width: double.infinity,
                  color: Colors.green.withOpacity(0.3),
                  child: Column(
                    children: const [
                      SpaceH30(),
                      Text('48px'),
                    ],
                  ),
                ),
              ],
            ),
            const SpaceH20(),
            SPaymentSelectFiat(
              icon: const SActionBuyIcon(),
              name: 'Fiat currency',
              amount: '\$0.00',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
