import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  height: 22.h,
                  width: 200.w,
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
                      height: 40.h,
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
                      height: 24.h,
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
                        SizedBox(
                          width: 125.w,
                        ),
                        const SpaceW10(),
                        Container(
                          width: 94.w,
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
                          width: 24.w,
                          height: 24.w,
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
                      width: 24.w,
                      height: 88.h,
                      child: const Text('24px'),
                    ),
                    const SpaceW24(),
                    Container(
                      width: 10.w,
                      height: 88.h,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('10px'),
                    ),
                    Container(
                      width: 125.w,
                      height: 88.h,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '125px',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 10.w,
                      height: 88.h,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('10px'),
                    ),
                    Container(
                      width: 158.w,
                      height: 88.h,
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
                    SizedBox(
                      width: 10.w,
                      height: 88.h,
                    ),
                    SizedBox(
                      width: 125.w,
                      height: 88.h,
                    ),
                    Column(
                      children: [
                        const SpaceH30(),
                        Row(
                          children: [
                            Container(
                              width: 152.w,
                              height: 30.h,
                              color: Colors.blue.withOpacity(0.2),
                              child: const Text('    94px'),
                            ),
                            Container(
                              width: 16.w,
                              height: 30.h,
                              color: Colors.white.withOpacity(0.2),
                              child: const Text('16px'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.blue.withOpacity(0.2),
                      width: 24.w,
                      height: 88.h,
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
