import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../ui/widgets/wallet_body/eur_wallet_body.dart';
import '../ui/widgets/wallet_body/wallet_body.dart';

void navigateToWallet(BuildContext context, CurrencyModel currency, {bool isSinglePage = false}) {
  final savedCurrencies = currenciesForMyWallet();

  final isCurrencySaved = savedCurrencies.any((element) => element.symbol == currency.symbol);

  if (isCurrencySaved && !isSinglePage) {
    sRouter
        .push(
      WalletRouter(
        currency: currency,
      ),
    )
        .then((value) {
      sAnalytics.tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen(
        openedAsset: currency.symbol,
      );
    });
  } else {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => WalletBody(
          currency: currency,
          isSinglePage: true,
        ),
      ),
    )
        .then((value) {
      sAnalytics.cryptoFavouriteWalletScreen(
        openedAsset: currency.symbol,
      );
      sAnalytics.tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen(
        openedAsset: currency.symbol,
      );
    });
  }
}

void navigateToEurWallet({required BuildContext context, required CurrencyModel currency, bool isSinglePage = false}) {
  Navigator.of(context)
      .push(
    MaterialPageRoute(
      builder: (context) => EurWalletBody(
        eurCurrency: currency,
        isSinglePage: isSinglePage,
      ),
    ),
  )
      .then((value) {
    sAnalytics.cryptoFavouriteWalletScreen(
      openedAsset: currency.symbol,
    );
    sAnalytics.tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen(
      openedAsset: currency.symbol,
    );
  });
}
