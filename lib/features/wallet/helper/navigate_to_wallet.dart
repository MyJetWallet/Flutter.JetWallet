import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

void navigateToWallet(BuildContext context, CurrencyModel currency) {
  if (currency.symbol == 'EUR') {
    sRouter.push(
      const EurWalletRouter(),
    );
  } else if (currency.isAssetBalanceEmpty && !currency.isPendingDeposit) {
    sRouter.push(
      EmptyWalletRouter(
        currency: currency,
      ),
    );
  } else {
    sRouter.push(
      WalletRouter(
        currency: currency,
      ),
    );
  }
}
