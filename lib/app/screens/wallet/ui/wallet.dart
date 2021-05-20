import 'package:flutter/material.dart';

import '../../../../shared/components/spacers.dart';
import '../../../shared/models/currency_model.dart';
import 'components/currencies_header.dart';
import 'components/currency_button/currency_button.dart';
import 'components/wallet_balance.dart';

const _mockCurrency = CurrencyModel(
  name: 'Bitcoin',
  symbol: 'BTC',
  image: 'https://bitcoin.org/img/icons/opengraph.png?1621091491',
  amount: 10,
  baseCurrencySymbol: 'USD',
  baseCurrencyAmount: 430202,
);

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
            const CurrencyButton(
              currency: _mockCurrency,
            )
        ],
      ),
    );
  }
}
