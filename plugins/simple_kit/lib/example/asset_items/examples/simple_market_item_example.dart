import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleMarketItemExample extends StatelessWidget {
  const SimpleMarketItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_market_item_example';

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
                  child: SMarketItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Bitcoin',
                    price: '\$57 415.80',
                    ticker: 'BTC',
                    percent: -0.6,
                  ),
                ),
                Container(
                  height: 22.0,
                  width: 200.0,
                  color: Colors.blue.withOpacity(0.2),
                  child: const Center(
                    child: Text(
                      '22px',
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 40.0,
                      color: Colors.green.withOpacity(0.2),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: const [
                              SpaceW90(),
                              SpaceW60(),
                              Center(
                                child: Text(
                                  '40px',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24.0,
                      color: Colors.purple.withOpacity(0.2),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: const [
                              SpaceW90(),
                              SpaceW60(),
                              Center(
                                child: Text(
                                  '24px',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const SpaceH22(),
                    Row(
                      children: [
                        const SpaceW24(),
                        const SpaceW24(),
                        const SpaceW10(),
                        const SizedBox(
                          width: 125.0,
                        ),
                        const SpaceW10(),
                        Container(
                          width: 94.0,
                        ),
                        const SpaceW16(),
                        const SpaceW24(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SpaceH40(),
            Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: SMarketItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Bitcoin',
                    price: '\$57 415.80',
                    ticker: 'BTC',
                    percent: -0.6,
                  ),
                ),
                Column(
                  children: [
                    const SpaceH22(),
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
                    Container(
                      color: Colors.blue.withOpacity(0.2),
                      width: 24.0,
                      height: 88.0,
                      child: const Text('24px'),
                    ),
                    const SpaceW24(),
                    Container(
                      width: 10.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('10px'),
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
                      width: 10.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('10px'),
                    ),
                    Container(
                      width: 158.0,
                      height: 88.0,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '158px',
                          ),
                        ],
                      ),
                    ),
                    const SpaceW24(),
                  ],
                ),
                Row(
                  children: [
                    const SpaceW24(),
                    const SpaceW24(),
                    const SizedBox(
                      width: 10.0,
                      height: 88.0,
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 10.0,
                      height: 88.0,
                    ),
                    Column(
                      children: [
                        const SpaceH30(),
                        Row(
                          children: const [
                            SizedBox(
                              width: 158.0,
                              height: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.blue.withOpacity(0.2),
                      width: 24.0,
                      height: 88.0,
                      child: const Text('24 px'),
                    ),
                  ],
                ),
              ],
            ),
            const SpaceH20(),
            SMarketItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Bitcoin',
              price: '\$57 415.80',
              ticker: 'BTC',
              percent: -0.6,
            ),
            SMarketItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Bitcoin',
              price: '\$57 415.80',
              ticker: 'BTC',
              percent: 10,
            ),
          ],
        ),
      ),
    );
  }
}
