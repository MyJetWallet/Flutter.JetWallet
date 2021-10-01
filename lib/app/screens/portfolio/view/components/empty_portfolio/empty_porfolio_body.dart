import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/features/currency_buy/view/curency_buy.dart';
import '../../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';

class EmptyPortfolioBody extends HookWidget {
  const EmptyPortfolioBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      useProvider(currenciesPod),
      'BTC',
    );

    return Container(
      padding: EdgeInsets.all(24.r),
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Get free crypto with every trade over \$10',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SpaceH20(),
          Text(
            'Make a first trade and be rewarded',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SpaceH25(),
          AppButtonSolid(
            name: 'Buy Bitcoin',
            onTap: () {
              navigatorPush(
                context,
                CurrencyBuy(
                  currency: currency,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
