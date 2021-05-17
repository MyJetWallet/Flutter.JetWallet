import 'package:flutter/material.dart';

import '../../../../shared/components/spacers.dart';

import 'components/currencies_header.dart';
import 'components/currency_card.dart';
import 'components/wallet_balance.dart';

const temp = 'https://bitcoin.org/img/icons/opengraph.png?1621091491';

class Wallet extends StatelessWidget {
  const Wallet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          WalletBalance(),
          const SpaceH20(),
          const CurrenciesHeader(),
          for (var i = 0; i < 20; i++)
            const CurrencyCard(
              name: 'Bitcoin',
              symbol: 'BTC',
              image: temp,
              amount: 0,
              baseCurrencySymbol: 'USD',
              baseCurrencyAmount: 0,
            )
        ],
      ),
    );
  }
}
