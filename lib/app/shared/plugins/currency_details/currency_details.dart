import 'package:flutter/material.dart';

import '../../../../shared/components/spacers.dart';
import '../../helpers/navigator_push.dart';
import '../../models/currency_model.dart';
import '../deposit/deposit.dart';
import '../withdraw/withdraw.dart';
import 'components/currency_details_balance.dart';
import 'components/currency_details_button.dart';
import 'components/currency_details_header.dart';
import 'components/currency_details_history.dart';

class CurrencyDetails extends StatelessWidget {
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
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              CurrencyDetailsHeader(
                currency: currency,
              ),
              const SpaceH10(),
              CurrencyDetailsBalance(
                currency: currency,
              ),
              const SpaceH20(),
              CurrencyDetailsButton(
                name: 'Deposit',
                onTap: () {
                  navigatorPush(
                    context,
                    Deposit(currency: currency),
                  );
                },
              ),
              const SpaceH20(),
              CurrencyDetailsButton(
                name: 'Withdraw',
                onTap: () {
                  navigatorPush(
                    context,
                    Withdraw(currency: currency),
                  );
                },
              ),
              const SpaceH20(),
              CurrencyDetailsButton(
                name: 'Convert',
                onTap: () {},
              ),
              const SpaceH20(),
              CurrencyDetailsHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
