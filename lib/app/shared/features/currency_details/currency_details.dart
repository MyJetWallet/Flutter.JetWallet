import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../screens/market/model/currency_model.dart';
import '../convert/view/convert.dart';
import '../currency_deposit/view/currency_deposit.dart';
import '../currency_withdraw/view/currency_withdraw.dart';
import 'components/currency_details_balance.dart';
import 'components/currency_details_button.dart';
import 'components/currency_details_header.dart';
import 'components/currency_details_history.dart';

class CurrencyDetails extends HookWidget {
  const CurrencyDetails({
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 15.h,
          ),
          child: ListView(
            children: [
              CurrencyDetailsHeader(
                currency: currency,
              ),
              const SpaceH8(),
              CurrencyDetailsBalance(
                currency: currency,
              ),
              const SpaceH15(),
              if (currency.isDepositMode)
                CurrencyDetailsButton(
                  name: 'Deposit',
                  onTap: () {
                    navigatorPush(
                      context,
                      CurrencyDeposit(currency: currency),
                    );
                  },
                ),
              const SpaceH15(),
              if (currency.isWithdrawalMode)
                CurrencyDetailsButton(
                  name: 'Withdraw',
                  onTap: () {
                    navigatorPush(
                      context,
                      CurrencyWithdraw(currency: currency),
                    );
                  },
                ),
              const SpaceH15(),
              CurrencyDetailsButton(
                name: 'Convert',
                onTap: () {
                  navigatorPush(
                    context,
                    Convert(currency: currency),
                  );
                },
              ),
              const SpaceH15(),
              CurrencyDetailsHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
