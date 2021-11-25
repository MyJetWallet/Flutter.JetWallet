import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleWalletItemExample extends StatelessWidget {
  const SimpleWalletItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_wallet_item_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                color: Colors.grey[200],
                child: SWalletItem(
                  onTap: () {},
                  icon: const SActionBuyIcon(),
                  primaryText: 'Bitcoin',
                  decline: false,
                  amount: '\$57 415.80',
                  secondaryText: 'BTC',
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
              Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 150.w,
                    height: 50.h,
                    color: Colors.red.withOpacity(0.2),
                    child: const Center(
                      child: Text(
                        '50px',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SpaceH40(),
          SWalletItem(
            onTap: () {},
            icon: const SActionBuyIcon(),
            primaryText: 'Bitcoin really long really long really long',
            decline: false,
            secondaryText: 'BTC',
          ),
          SWalletItem(
            onTap: () {},
            icon: const SActionBuyIcon(),
            primaryText: 'Bitcoin really long',
            amount: '\$0 000 000.00',
            decline: false,
            secondaryText: 'BTC',
          ),
          SWalletItem(
            onTap: () {},
            icon: const SActionBuyIcon(),
            removeDivider: true,
            primaryText: 'Bitcoin really long long',
            amount: '\$57 415.80',
            decline: false,
            secondaryText: 'BTC',
          ),
          SWalletItem(
            onTap: () {},
            icon: const SActionBuyIcon(),
            removeDivider: true,
            primaryText: 'Bitcoin really long long',
            amount: '\$57 415.80',
            decline: true,
            secondaryText: 'BTC',
          ),
        ],
      ),
    );
  }
}
