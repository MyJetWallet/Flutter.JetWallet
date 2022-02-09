import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleFiatItemExample extends StatelessWidget {
  const SimpleFiatItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_fiat_item_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: SFiatItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Fiat Currency',
                    amount: '\$1000000.00',
                  ),
                ),
                Column(
                  children: [
                    const SpaceH32(),
                    Row(
                      children: [
                        const SpaceW24(),
                        Container(
                          width: 24.0,
                          height: 24.0,
                          color: Colors.purple.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SpaceW24(),
                    const SpaceW24(),
                    Container(
                      width: 20.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    Expanded(
                      child: Container(
                        height: 88.0,
                        color: Colors.red.withOpacity(0.2),
                        child: Column(
                          children: const [
                            Spacer(),
                            Text(
                              'Expanded',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 16.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('16px'),
                    ),
                    Container(
                      width: 120.0,
                      height: 88.0,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '120px',
                          ),
                        ],
                      ),
                    ),
                    const SpaceW24(),
                  ],
                ),
                Container(
                  height: 32.0,
                  color: Colors.blue.withOpacity(0.2),
                  child: const Center(
                    child: Text(
                      '32px',
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 50.0,
                      color: Colors.green.withOpacity(0.2),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: const [
                              SpaceW90(),
                              SpaceW90(),
                              SpaceW30(),
                              Center(
                                child: Text(
                                  '50px',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            const SpaceH20(),
            SFiatItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Fiat Currency',
              amount: '\$1000000.00',
            ),
          ],
        ),
      ),
    );
  }
}
