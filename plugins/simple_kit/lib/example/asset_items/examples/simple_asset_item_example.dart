import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleAssetItemExample extends StatelessWidget {
  const SimpleAssetItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_asset_item_example';

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
                  child: SAssetItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Asset Name',
                    amount: '\$1000000.00',
                    description: 'Description',
                    helperText: 'Helper text',
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
                    const SpaceW24(),
                    const SpaceW24(),
                    Container(
                      width: 20.w,
                      height: 88.h,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    Container(
                      width: 150.w,
                      height: 88.h,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '150px',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 120.w,
                      height: 88.h,
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
                  height: 22.h,
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
                              SpaceW90(),
                              SpaceW30(),
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
                      height: 20.h,
                      color: Colors.purple.withOpacity(0.2),
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
                                  '20px',
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
            SAssetItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Asset Name',
              amount: '\$1000000.00',
              description: 'Description',
              helperText: 'Helper text',
            ),
            const SpaceH20(),
            Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: SAssetItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    isCreditCard: true,
                    name: 'Card Name',
                    amount: '**** 0000',
                    description: 'Date',
                    helperText: 'Limit',
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
                    const SpaceW24(),
                    const SpaceW24(),
                    Container(
                      width: 20.w,
                      height: 88.h,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    Container(
                      width: 180.w,
                      height: 88.h,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '180px',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 90.w,
                      height: 88.h,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '90px',
                          ),
                        ],
                      ),
                    ),
                    const SpaceW24(),
                  ],
                ),
                Container(
                  height: 22.h,
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
                              SpaceW90(),
                              SpaceW30(),
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
                      height: 20.h,
                      color: Colors.purple.withOpacity(0.2),
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
                                  '20px',
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
            SAssetItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              isCreditCard: true,
              name: 'Card Name',
              amount: '**** 0000',
              description: 'Date',
              helperText: 'Limit',
            ),
          ],
        ),
      ),
    );
  }
}
