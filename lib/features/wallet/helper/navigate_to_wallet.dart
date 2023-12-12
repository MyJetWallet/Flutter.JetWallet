import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/wallet_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

void navigateToWallet(BuildContext context, CurrencyModel currency) {
  final savedCurrencies = currenciesForMyWallet();

  final isCurrencySaved = savedCurrencies.any((element) => element.symbol == currency.symbol);

  if (isCurrencySaved) {
    sRouter.push(
      WalletRouter(
        currency: currency,
      ),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletBody(
          currency: currency,
          isSinglePage: true,
        ),
      ),
    );
  }
}
