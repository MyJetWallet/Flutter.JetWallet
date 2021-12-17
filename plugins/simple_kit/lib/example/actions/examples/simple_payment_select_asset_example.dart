import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimplePaymentSelectAssetExample extends StatelessWidget {
  const SimplePaymentSelectAssetExample({Key? key}) : super(key: key);

  static const routeName = '/simple_payment_select_asset_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SPaymentSelectAsset(
                  icon: const SActionBuyIcon(),
                  name: 'Asset name',
                  amount: '\$0.00',
                  description: 'Asset Balance',
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
                          const SpaceH26(),
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
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 26.0,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Text(
                        '26px',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 16.0,
                      width: double.infinity,
                      color: Colors.green.withOpacity(0.3),
                      child: Column(
                        children: const [
                          Text('42px'),
                        ],
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: double.infinity,
                      color: Colors.purple.withOpacity(0.3),
                      child: Column(
                        children: const [
                          Text('20px'),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SpaceH20(),
            Stack(
              children: [
                SPaymentSelectAsset(
                  icon: const SActionBuyIcon(),
                  name: 'Card name',
                  amount: '**** 0000',
                  description: 'Date',
                  helper: 'Limit',
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
                          const SpaceH26(),
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
                        width: 150.0,
                        height: 88.0,
                        color: Colors.red.withOpacity(0.2),
                        child: Column(
                          children: const [
                            Spacer(),
                            Text('150px'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 90.0,
                        height: 88.0,
                        color: Colors.red.withOpacity(0.2),
                        child: Column(
                          children: const [
                            Spacer(),
                            Text('90px'),
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
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 26.0,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Text(
                        '26px',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 16.0,
                      width: double.infinity,
                      color: Colors.green.withOpacity(0.3),
                      child: Column(
                        children: const [
                          Text('42px'),
                        ],
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: double.infinity,
                      color: Colors.purple.withOpacity(0.3),
                      child: Column(
                        children: const [
                          Text('20px'),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SpaceH20(),
            SPaymentSelectAsset(
              icon: const SActionBuyIcon(),
              name: 'Asset name',
              amount: '\$0.00',
              description: 'Asset Balance',
              onTap: () {},
            ),
            const SpaceH20(),
            SPaymentSelectAsset(
              icon: const SActionBuyIcon(),
              isCreditCard: true,
              name: 'Card name',
              amount: '**** 0000',
              description: 'Date',
              helper: 'Limit',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
