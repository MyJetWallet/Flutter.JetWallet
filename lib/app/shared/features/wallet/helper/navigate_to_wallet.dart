import 'package:flutter/material.dart';

import '../../../models/currency_model.dart';
import '../view/empty_wallet.dart';
import '../view/wallet.dart';

void navigateToWallet(BuildContext context, CurrencyModel currency) {
  if (currency.isAssetBalanceEmpty) {
    EmptyWallet.push(
      context: context,
      assetName: currency.description,
    );
  } else {
    Wallet.push(
      context: context,
      assetId: currency.assetId,
    );
  }
}
